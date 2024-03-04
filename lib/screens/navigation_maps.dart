import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
  GoogleMapController? mapController;
  final TextEditingController _destinationController = TextEditingController();
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
  String apiKey = "AIzaSyBhwULmCSuNyr7hpqt-u9zEHydv31ucMfo";

  @override
  void initState() {
    super.initState();
    apiKey = 'AIzaSyBhwULmCSuNyr7hpqt-u9zEHydv31ucMfo';
    googlePlace = GooglePlace(apiKey);

    _requestLocationPermission();

    endFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    endFocusNode.dispose();
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
            top: MediaQuery.sizeOf(context).height / 4,
            child: Column(
              children: [
                Container(
                    width: MediaQuery.sizeOf(context).width/3,
                    height: MediaQuery.sizeOf(context).height/3,
                    child: CameraView()),
                Container(
                    width: 100,
                    height: 100,
                    child: Obx(() => Text(Get.find<ScanController>().detectionResult.value))),
              ],
            ),
          )
        ],
      ),
    );
  }

  void autoCompleteSearch(String value) async{
    var result = await googlePlace.autocomplete.get(value);
    if(result != null && result.predictions != null && mounted){
      print(result.predictions!.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TurnByTurnScreen(
        startLatitude: s1!,
        startLongitude: s2!,
        endLatitude: endPosition!.geometry!.location!.lat!,
        endLongitude: endPosition!.geometry!.location!.lng!,
      )),
    );

  }

}