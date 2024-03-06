import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
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

//import 'package:alan_voice/alan_voice.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'package:flutter_tts/flutter_tts.dart';


void main(){
  runApp(mapPage());
}

class mapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavMaps',
      home: LocationMap(),
    );
  }
}

class LocationMap extends StatefulWidget {
  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  _LocationMapState(){
    /*AlanVoice.addButton("689e5df914105717e09b84ae8ac4018d2e956eca572e1d8b807a3e2338fdd0dc/stage");

    AlanVoice.playCommand("active now");

    AlanVoice.onCommand.add((command) {
      debugPrint("got new command ${command.toString()}");
    });
    AlanVoice.callbacks.add((command) {
      _handleCommand(command.data);
    });*/
    _flutterTts.setLanguage("en-US"); // Set English (US) as default language
    _flutterTts.setPitch(1.0); // Adjust pitch as needed (1.0 is default)
    _flutterTts.setSpeechRate(0.5);
  }
  //bool alanRuning = AlanVoice.isActive() as bool;

  /*void runAlan(){
    AlanVoice.addButton("689e5df914105717e09b84ae8ac4018d2e956eca572e1d8b807a3e2338fdd0dc/stage");
    AlanVoice.playCommand("active now");
    AlanVoice.playCommand("command");

    AlanVoice.onCommand.add((command) {
      debugPrint("got new command ${command.toString()}");
    });
  }*/

  void _handleCommand(Map<String, dynamic> command) {
    switch(command["command"]){
      case "start":
        ;
        break;
      case "decrement":
        ;
        break;
      default:
        debugPrint("Unknown Command");
    }
  }

  @override
  void initState(){
    super.initState();
    _requestLocationPermission();

    setState(() => _isListening = false);

    _initSpeech();
    _flutterTts.speak("Welcome to Navigation");

    apiKey = 'AIzaSyBhwULmCSuNyr7hpqt-u9zEHydv31ucMfo';
    googlePlace = GooglePlace(apiKey);
    endFocusNode = FocusNode();


    _navReady = false;
  }

  final FlutterTts _flutterTts = FlutterTts();


  late TextEditingController _numberController = TextEditingController();

  bool _navReady = false;

  SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  bool _isSpeaking = false;
  String _lastWords = '';
  Duration? listenDelay = Duration(seconds: 3);

  void _initSpeech() async {
    await Future.delayed(listenDelay!);
    _requestMicrophoneAcess();
    _speechToText.initialize();
    _speechToText.listen(
      listenFor: listenDelay,
    );
    setState(() {});
  }
  _startListening() async {
    try {
      print("_startListening");
      print(_isListening);
      print(_isSpeaking);
      if (_isListening && !_isSpeaking) {
        await _speechToText.listen(onResult: _onSpeechResult);
        await Future.delayed(Duration(seconds: 5));
        _isListening = false;
        print(_isListening);
      }
      setState(() {
        _lastWords = '';
      });
      print("_startListening");
    }
    catch (e){
      _isListening = false;
      print(e);
    }
  }
  void _stopListening() async {
    if (_isListening) {
      _isListening = false;
      await _speechToText.stop();
    }
    setState(() {});
  }

  _speak(String Text) async {
    print("_speak");
    if (!_isListening){
      setState(() => _isSpeaking = true);
      print(_isSpeaking);
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.speak(Text);
      setState(() => _isSpeaking = false);
      print(_isSpeaking);
      print("_speak");
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    print("_onSpeechResult");
    print(_isListening);
    print(_isSpeaking);
    if (_isSpeaking){
      return null;
    }
    setState(() {
      _lastWords = result.recognizedWords;
      _destinationController.text = _lastWords;
      _flutterTts.speak(_lastWords);
      print(_lastWords);
    });
    autoCompleteSearch(_lastWords);
    print("_onSpeechResult");
  }

  int? _getNumValue(){
    try {
      return int.parse(_numberController.text)-1;
    } catch (e){
      return null;
    }
  }

  String _numValue = '';
  _numListener() async {
    print("_numListener");
    _numValue = '';
    print(_isListening);
    print(_isSpeaking);
    if (_isListening && !_isSpeaking) {
      await _speechToText.listen(onResult: _onNumResult);
      await Future.delayed(Duration(seconds: 5));
      _isListening = false;
      print(_isListening);
    }
    setState(() {
      _numValue = '';
    });
    print("_numListener");
  }
  void _onNumResult(SpeechRecognitionResult numResult){
    print("_onNumResult");
    print(_isListening);
    print(_isSpeaking);
    if (_isSpeaking){
      return null;
    }
    setState(() {
      _numValue = numResult.recognizedWords;
      _numberController.text = _numValue;
      _flutterTts.speak(_numValue);
      print(_numValue);
    });
    print("_onNumResult");
  }

  _enterDestination() async{
    _requestMicrophoneAcess();
    _navReady = false;
    print("_enterDestination");
    print(_isListening);
    print(_isSpeaking);
    if (_isListening || _isSpeaking){
      return null;
    }
    _lastWords = '';
    print(_lastWords);
    _destinationController.clear();
    predictions.clear();
    _isSpeaking = true;
    await _speak("Where do you want to go?");
    print("POINT 1");
    _flutterTts.awaitSpeakCompletion(true);
    //AlanVoice.deactivate();
    _isListening = true;
    await Future.delayed(const Duration(seconds: 1));
    print("POINT 2");
    await _startListening();
    _isListening = false;
    print("_enterDestination");
  }

  GoogleMapController? mapController;
  final TextEditingController _destinationController = TextEditingController();
  Set<Marker> markers = {};

  final int delayInMilliseconds = 2000;

  Position? currentPosition;
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  DetailsResult? endPosition;
  late FocusNode endFocusNode;
  double? s1,s2,e1,e2;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String apiKey = "AIzaSyBhwULmCSuNyr7hpqt-u9zEHydv31ucMfo";



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _flutterTts.stop();
    _speechToText.stop();
    endFocusNode.dispose();
  }

  voiceMain() async {
    await _enterDestination();
    await Future.delayed(const Duration(seconds: 1));

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2FEFE),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.keyboard_voice_rounded)
        ],
        color: mainThemeColor,
        backgroundColor: Colors.white,
        height: 60,
      ),
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
                      print(value);
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
                              _stopListening();
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
                      _enterDestination();
                    },
                    child: Text('Start', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text("CLICKME"),
              onPressed: () async {
                await readPredictions();
                await _selectLocation();
                await _setData();
                if (_navReady){
                  _requestLocationPermission();
                  _setDestination();
                  _getPolyline();
                }
              },
            ),
          ),
          Positioned(
            left: 5,
            top: MediaQuery.sizeOf(context).height / 4,
            child: Column(
              children: [
                Container(
                    width: MediaQuery.sizeOf(context).width/3,
                    height: MediaQuery.sizeOf(context).height/3,
                    child: CameraView()
                    ),
                Container(
                    width: 100,
                    height: 100,
                    child: Obx(() => Text(Get.find<ScanController>().detectionResult.value))
                    ),
              ],
            ),
          )
        ],
      ),
    );
  }

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

  Future<void> readPredictions() async {
    for (int i = 0; i < predictions.length; i++) {
      int x = i + 1;
      String num = x.toString();
      await _speak("0"+num);
      _flutterTts.awaitSpeakCompletion(true);
      String placePredictions = predictions[i].description.toString();
      await _speak(placePredictions);
      _flutterTts.awaitSpeakCompletion(true);
      print(placePredictions);
    }
    _isSpeaking = false;
  }

  Future<void> _selectLocation() async {
    print("_selectLocation");
    print(_isListening);
    print(_isSpeaking);
    if (!_isSpeaking && !_isListening) {
      await _speak("Select a number");
      print("break 1");
      print(_isListening);
      print(_isSpeaking);
      if (!_isSpeaking) {
        _isListening = true;
        _numValue = '';
        await _numListener();
        await Future.delayed(Duration(seconds: 3));
        print(_numberController.text);
        print(_isListening);
        print(_isSpeaking);
      }
    }
    print("_selectLocation");
  }

  _setData() async {
    print("_setData");
    print(_isListening);
    print(_isSpeaking);
    if(!_isListening){
      await _speak(_numberController.text); //numberCController,text
      print("your number is "+ _numberController.text);
    }
    int? num = _getNumValue();
    print(num);
    try{
      if (num!<0 || num>= predictions.length) {
        _navReady = false;
        print("BREAK 1");
        _enterDestination();
        return;
      }
      print("BREAK 2");
      final placeId = predictions[num].placeId!;
      final details = await googlePlace.details.get(placeId);
      print(details);
      print(details?.result);
      if (details != null && details.result != null) {
        print("BREAK 3");
        setState(() {
          endPosition = details.result;
          _destinationController.text = details.result!.name!;
          print(_numberController.text + _destinationController.text);
          _speak(_numberController.text+_destinationController.text);
          predictions = [];
          _navReady = true;
        });
      } else {
        _navReady = false;
        _enterDestination();
      }
    }
    catch (e){
      _navReady = false;
      _enterDestination();
    }
    print("_setData");
  }

  void _onMapCreated(GoogleMapController controller){
    setState(() {
      mapController = controller;
    });
  }

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
      print('Error getting current location: $e');
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      _getCurrentLocation();
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else {
      print('error');
    }
  }

  Future<void> _requestMicrophoneAcess() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      return;
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else {
      print('error');
    }
  }

  void openAppSettings() async {
    // Use the appropriate URI/intent based on the platform (Android/iOS)
    final url = Platform.isAndroid
        ? 'package:com.android.settings'
        : 'app-settings://';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(url as Uri);
    } else {
      // Handle the case where the URL cannot be launched
      print('Could not launch app settings');
    }
  }

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

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

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
    Future.delayed(Duration(milliseconds: delayInMilliseconds), ()
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