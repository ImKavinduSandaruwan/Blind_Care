import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projectblindcare/screens/turnbyturn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:projectblindcare/components/camera_view.dart';
import '../components/scan_controller.dart';
import '../constants/constant.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter_tts/flutter_tts.dart';


class LocationMap extends StatefulWidget {
  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  _LocationMapState(){
    AlanVoice.addButton(
      "689e5df914105717e09b84ae8ac4018d2e956eca572e1d8b807a3e2338fdd0dc/stage",
      buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT,
    );
    AlanVoice.activate();
    AlanVoice.onCommand.add((command) {
      debugPrint("got new command ${command.toString()}");});
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  /// Handles various commands received from the Alan AI dialog script.
  /// Each command triggers a specific action within the app.
  Future<void> _handleCommand(Map<String, dynamic> command) async {
    switch(command["command"]) {
      case "getPlace":
        _destinationController.clear();
        _destinationController.text = command["text"];
        _lastWords = _destinationController.text;
        startProcessSubOne();
        break;
      case "getSelect":
        _numberSelect = true;
        _numberController.text = command["text"];
        startProcessSubTwo();
        break;
      default:
        debugPrint("Unknown command");
    }
  }

  /// Initializes the state of the widget.
  /// This method is called once when creating the state.
  /// It sets up the initial state of the widget, including requesting location permissions, initializing the Google Places API, and setting up focus nodes.
  /// It also initializes a boolean flag to indicate whether navigation is ready.
  @override
  void initState(){
    super.initState();
    _requestLocationPermission();
    apiKey = "AIzaSyALmRQFrUjSDzXK4TgxPM6iBvnfU6wfhuc";
    googlePlace = GooglePlace(apiKey);
    endFocusNode = FocusNode();
    _navReady = false;
  }

  /// Releases resources held by the widget.
  /// This method is called when the widget is removed from the widget tree permanently.
  /// It disposes of the focus node, text controllers, and any other resources to prevent memory leaks.
  /// Always ensure to call super.dispose() at the end to complete the disposal process.
  @override
  void dispose() {
    endFocusNode.dispose();
    _destinationController.dispose();
    _numberController.dispose();
    scanController.dispose();
    super.dispose();
  }

  late TextEditingController _numberController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Position? currentPosition;
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  DetailsResult? endPosition;
  late FocusNode endFocusNode;
  double? s1,s2,e1,e2;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String apiKey = "AIzaSyALmRQFrUjSDzXK4TgxPM6iBvnfU6wfhuc";
  bool _navReady = false;
  String _lastWords = '';
  String _numValue = '';
  bool _predictionsRead = false;
  bool _numberSelect = false;
  final FlutterTts _flutterTts = FlutterTts();
  ScanController scanController = ScanController();
  var detectedText;

  Future<bool> _checkIsActive() async {
    var isActive = await AlanVoice.isActive();
    if (isActive) {
      return true;
    } else {
      return false;
    }
  }

  /// Initializes the Text-to-Speech (TTS) settings.
  /// This function sets the language to English (US),
  /// adjusts the speech rate, and ensures that the TTS
  /// engine waits for the completion of the current speech before starting a new one.
  /// It uses the FlutterTts package to configure the TTS settings.
  void initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.awaitSpeakCompletion(true);
  }

  /// Asynchronously speaks the provided text using Text-to-Speech (TTS).
  /// This function first checks if the TTS engine is active.
  /// If the TTS engine is active and the text does not contain the word "others", it proceeds to speak the text.
  /// It uses the FlutterTts package to convert the text to speech.
  /// After speaking the text, it waits for the completion of the speech before proceeding.
  _speak(String textSpeech) async {
    if (await _checkIsActive() == false) {
      if(!textSpeech.toLowerCase().contains("others")){
        await _flutterTts.speak(textSpeech);
        await _flutterTts.awaitSpeakCompletion(true);
      }
    }
  }

  /// Attempts to parse the text from a TextEditingController as an integer.
  /// This function subtracts 1 from the parsed integer value.
  /// It uses a try-catch block to handle any FormatException that may occur during parsing.
  /// If parsing is successful, it returns the parsed integer value minus 1.
  /// If a FormatException occurs, it returns null.
  int? _getNumValue(){
    try {
      return int.parse(_numberController.text)-1;
    } catch (e){
      return null;
    }
  }

  /// Asynchronously initiates a series of operations with delays between each step.
  /// This function first calls _enterDestination to presumably enter a destination.
  /// It then waits for 5 seconds using Future.delayed.
  /// After the delay, it reads predictions by calling _readPredictions.
  /// Another 3-second delay is introduced before selecting a location with _selectLocation.
  /// The use of Future.delayed allows for pausing execution between operations,
  /// which can be useful for simulating real-world delays or for UI feedback purposes.
  startProcessSubOne() async {
    _enterDestination();
    await Future.delayed(Duration(seconds: 5));
    await _readPredictions();
    await Future.delayed(Duration(seconds: 3));
    await _selectLocation();
  }

  /// Asynchronously sets data, waits for a short duration, and conditionally performs location-related operations.
  /// This function first sets data by calling _setData and waits for 3 seconds using Future.delayed.
  /// It then checks if navigation is ready (_navReady) before proceeding with location-related operations.
  /// If navigation is ready, it requests location permission, sets the destination, and retrieves a polyline.
  /// The use of Future.delayed allows for pausing execution between operations,
  /// which can be useful for simulating real-world delays or for UI feedback purposes.
  startProcessSubTwo() async {
    await _setData();
    Future.delayed(Duration(seconds: 3));
    if (_navReady){
      _requestLocationPermission();
      _setDestination();
      _getPolyline();
    }
  }

  /// Asynchronously processes the destination input for autocomplete suggestions.
  /// This function clears any existing predictions, retrieves the last entered
  /// words from the destination controller,
  /// and initiates an autocomplete search based on those words.
  /// It also resets flags for predictions read and number selection
  /// to ensure a fresh start for the next destination input.
  _enterDestination() async {
    predictions.clear();
    _lastWords = _destinationController.text;
    autoCompleteSearch(_lastWords);
    _predictionsRead = false;
    _numberSelect = false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2FEFE),
      appBar: AppBar(
        backgroundColor: mainThemeColor,
        title: const Text(
          "Navigation",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins'
          ),
        ),
      ),
      body: Stack(
        children: [
          if (currentPosition != null)
            GoogleMap(
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentPosition!.latitude ?? 0.0,
                  currentPosition!.longitude ?? 0.0,
                ),
                zoom: 15.0,
              ),
              myLocationEnabled: true,
              markers: markers,
              padding: const EdgeInsets.only(top: 100.0),
            ),
          Positioned(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _destinationController,
                  focusNode: endFocusNode,
                  decoration: InputDecoration(
                      hintText: 'Enter Destination',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: const OutlineInputBorder(),
                      suffixIcon: _destinationController.text.isNotEmpty ?
                      IconButton(
                        onPressed: (){
                          setState(() {
                            predictions = [];
                            _destinationController.clear();
                          });
                        }, icon: const Icon(Icons.clear_outlined),
                      )
                          :null),
                    onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      setState(() {
                        predictions = [];
                        endPosition = null;
                      });
                    }
                  },
                ),
                Container(
                  color: Colors.blueGrey,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          predictions[index].description.toString(),
                        ),
                        onTap: () async {
                          final placeId = predictions[index].placeId!;
                          final details = await googlePlace.details.get(placeId);
                          if(details != null && details.result != null && mounted) {
                            setState(() {
                              endPosition = details.result;
                              _destinationController.text = details.result!.name!;
                              predictions = [];
                            });
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            right: 75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _requestLocationPermission();
                      print("runner");
                      print(currentPosition?.latitude);
                      _setDestination();
                      _getPolyline();
                    },
                    child: Text('Start', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            left: 5,
            top: MediaQuery.sizeOf(context).height / 5,
            child: Column(
              children: [
                Container(
                    width: MediaQuery.sizeOf(context).width/3,
                    height: MediaQuery.sizeOf(context).height/3,
                    child: CameraView()
                    ),
                Container(
                    width: MediaQuery.sizeOf(context).width/3,
                    height: MediaQuery.sizeOf(context).height/7,
                    child: Obx(() => objSpeech())
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  /// Processes the detected text from a scan and speaks it out using Text-to-Speech (TTS).
  /// This function retrieves the detection result from the ScanController,
  /// speaks the detected text using the _speak method,
  /// and returns a Text widget displaying the detected text.
  /// It leverages the GetX package for dependency injection and state management,
  objSpeech() {
    detectedText = Get.find<ScanController>().detectionResult.value;
    _speak(detectedText);
    return Text(detectedText);
  }

  /// Asynchronously performs an autocomplete search for location suggestions using the Google Places API.
  /// This function takes a search value as input and sends a request to the Google Places API to get autocomplete suggestions.
  /// It specifies the region as "LK" (Sri Lanka) for the search.
  /// Upon receiving the results, it prints the predictions and updates the
  /// UI state with the new predictions if the widget is still mounted.
  void autoCompleteSearch(String value) async{
    var result = await googlePlace.autocomplete.get(
        value,
        region: "LK",
    );
    if(result != null && result.predictions != null && mounted){
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  /// Asynchronously reads and speaks out autocomplete predictions using Alan AI.
  /// This function checks if predictions have already been read. If so, it returns early.
  /// If predictions are available, it iterates through each prediction,
  /// converting the index to a number string and speaking it out, followed by the prediction description.
  /// It sets a flag to indicate that predictions have been read to prevent re-reading.
  /// This function leverages the Alan AI Flutter plugin for text-to-speech functionality,
  Future<void> _readPredictions() async {
    if (_predictionsRead){
      return null;
    }
    if (predictions.isNotEmpty) {
      for (int i = 0; i < predictions.length; i++) {
        int x = i + 1;
        String num = "0"+x.toString();
        AlanVoice.playText(num);
        String placePredictions = predictions[i].description.toString();
        AlanVoice.playText(placePredictions);
        _predictionsRead = true;
      }
    }
  }

  /// Asynchronously handles the selection of a location from autocomplete predictions.
  /// This function checks if a location selection is already in progress or if there are no predictions available.
  /// If either condition is true, it returns early without performing any action.
  /// Otherwise, it prompts the user to select a number using Alan AI for text-to-speech functionality.
  /// It then retrieves the selected number from a TextEditingController and sets a flag to indicate that a number selection is in progress.
  /// This function leverages the Alan AI Flutter plugin for text-to-speech functionality,
  Future<void> _selectLocation() async {
    if (_numberSelect){
      return null;
    }
    if (predictions.isEmpty){
      return null;
    }
    String _selectString = "Select a number";
    AlanVoice.playText(_selectString);

    _numValue = '';
    _numValue = _numberController.text;
    _numberSelect = true;
  }

  /// Asynchronously sets data based on user input and updates the UI accordingly.
  /// This function plays the selected number using Alan AI for text-to-speech functionality.
  /// It retrieves the numeric value from the user input and checks if it's within the valid range of predictions.
  /// If the number is valid, it fetches the place details from the Google Places API using the selected prediction's place ID.
  /// Upon receiving the place details, it updates the UI with the new destination and clears the predictions list.
  /// It also sets a flag to indicate that navigation is ready.
  /// If the number is invalid or an error occurs, it sets a flag to indicate that navigation is not ready.
  _setData() async {
    AlanVoice.playText(_numValue);
    int? num = _getNumValue();
    try{
      if (num!<0 || num>= predictions.length) {
        _navReady = false;
        return null;
      }
      final placeId = predictions[num].placeId!;
      final details = await googlePlace.details.get(placeId);
      if (details != null && details.result != null) {
        setState(() {
          endPosition = details.result;
          _destinationController.text = details.result!.name!;
          String finalPlace = _numberController.text+_destinationController.text;
          AlanVoice.playText(finalPlace);
          predictions = [];
          _navReady = true;
        });
      } else {
        _navReady = false;
      }
    }
    catch (e){
      _navReady = false;
    }
  }


  void _onMapCreated(GoogleMapController controller){
    setState(() {
      mapController = controller;
    });
  }

  /// Asynchronously retrieves the current location of the device using the Geolocator package.
  /// This function attempts to get the current position with high accuracy.
  /// Upon successful retrieval, it updates the state with the current position and adds a marker to the map at the current location.
  /// If an error occurs during the process, it prints the error message to the debug console.
  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
      setState(() {
        currentPosition = position;
        markers.clear();
        markers.add(
            Marker(
              markerId: MarkerId('Start'),
              position: LatLng(position.latitude, position.longitude),
            )
        );
      });
    }
    catch (e){
      debugPrint('$e');
    }
  }

  /// Asynchronously requests location permission from the user.
  /// This function uses the PermissionHandler package to request location permission when the app is in use.
  /// If the permission is granted, it proceeds to get the current location.
  /// If the permission is permanently denied, it opens the app settings to allow the user to manually grant permission.
  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      _getCurrentLocation();
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else {
      debugPrint('error');
    }
  }

  /// Asynchronously opens the app settings page on the device.
  /// This function checks the platform and constructs the appropriate URL to open the app settings.
  /// For Android, it uses the package name to open the app settings directly.
  /// For iOS, it uses a generic URL scheme to open the app settings.
  /// It then attempts to launch the URL. If successful, it opens the app settings page.
  /// If the URL cannot be launched, it prints an error message to the debug console.
  /// This function leverages the platform-specific capabilities to open app settings,
  void openAppSettings() async {
    final url = Platform.isAndroid
        ? 'package:com.android.settings'
        : 'app-settings://';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(url as Uri);
    } else {
      debugPrint('error');
    }
  }

  /// Asynchronously sets the destination on the map and adjusts the camera view to include both the current position and the destination.
  /// This function retrieves the latitude and longitude of the current position and the destination.
  /// It calculates the north-east and south-west bounds based on the current and destination positions.
  /// It then animates the camera to fit these bounds, ensuring both the current position and the destination are visible on the map.
  /// It removes any existing 'End' marker and adds a new marker at the destination position.
  void _setDestination() async {
    s1 = currentPosition?.latitude;
    s2 = currentPosition?.longitude;
    e1 = endPosition!.geometry!.location!.lat!;
    e2 = endPosition!.geometry!.location!.lng!;

    double? ne1, ne2, sw1, sw2;
    if(s1!>e1!){
      ne1 = s1;
      sw1 = e1;
    } else{
      ne1 = e1;
      sw1 = s1;
    }
    if(s2!>e2!){
      ne2 = s2;
      sw2 = e2;
    } else{
      ne2 = e2;
      sw2 = s2;
    }
    mapController!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(sw1!-0.1,sw2!-0.1),
            northeast: LatLng(ne1!+0.1,ne2!+0.1)),
        1
    ));
    markers.remove('End');
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('End'),
          position: LatLng(
              endPosition!.geometry!.location!.lat!,
              endPosition!.geometry!.location!.lng!
          ),
        ),
      );
    });
  }

  /// Adds a polyline to the map to represent a route or path.
  /// This function creates a new polyline with a specified ID, color, and points.
  /// The polyline is then added to the map's polylines collection.
  /// Finally, it triggers a UI update to reflect the new polyline on the map.
  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  /// Asynchronously fetches polyline points between two coordinates and adds them to the map.
  /// This function clears any existing polyline coordinates and requests a route between the current position and the destination.
  /// It uses the flutter_polyline_points package to decode the polyline string into a list of geo-coordinates.
  /// If the result contains points, it adds these points to the polylineCoordinates list.
  /// It then calls _addPolyLine to draw the polyline on the map.
  /// After a delay, it navigates to a new screen, presumably to display turn-by-turn directions.
  _getPolyline() async {
    polylineCoordinates.clear();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(s1!, s2!),
      PointLatLng(e1!, e2!),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
    await Future.delayed(Duration(seconds: 2), ()
    {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            TurnByTurnScreen(
              startLatitude: s1!,
              startLongitude: s2!,
              endLatitude: endPosition!.geometry!.location!.lat!,
              endLongitude: endPosition!.geometry!.location!.lng!,
            ),
        ),
      );
      },
    );
  }
}