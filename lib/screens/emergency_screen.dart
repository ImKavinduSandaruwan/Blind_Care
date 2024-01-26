import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projectblindcare/constants/constant.dart';
import 'package:geolocator/geolocator.dart';


main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmergencyScreen(),
    );
  }
}

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  _emergencyFeature createState() => _emergencyFeature();
}

class _emergencyFeature extends State<EmergencyScreen> {

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Emergency handling",style: TextStyle(fontSize: 28,fontFamily:'Arial',fontWeight: FontWeight.bold)),
                          // Text("Want to contact someone?",style: TextStyle(fontSize: 24,fontFamily:'Arial',fontWeight: FontWeight.bold)),
                          Text("Contact nearest police station",style: TextStyle(fontSize: 22,fontFamily:'Arial')),
                          ElevatedButton(
                              onPressed: (){
                                FlutterPhoneDirectCaller.callNumber('+94763088444');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(153, 255, 153, 1.0), // Change the button color here
                              ),
                              child: Text("Kurunegala police station",style: TextStyle(fontSize: 22,fontFamily:'Arial',fontWeight: FontWeight.bold,color: Color.fromRGBO(89, 89, 89, 1.0))
                              )
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text("Contact List",style: TextStyle(fontSize: 22,fontFamily:'Arial')),
                          Container(
                            height: 150.0,
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromRGBO(153, 255, 153, 1.0), // Change the button color here
                                    ),
                                    onPressed: () {
                                      FlutterPhoneDirectCaller.callNumber('+94763088444');
                                    },
                                    child: ListTile(
                                      leading: Icon(Icons.account_circle),
                                      title: Text("BENERT"),
                                      trailing: Icon(Icons.call),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromRGBO(153, 255, 153, 1.0), // Change the button color here
                                    ),
                                    onPressed: () {
                                      FlutterPhoneDirectCaller.callNumber('+94763088444');
                                    },
                                    child: ListTile(
                                      leading: Icon(Icons.account_circle),
                                      title: Text("BENERT"),
                                      trailing: Icon(Icons.call),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromRGBO(153, 255, 153, 1.0), // Change the button color here
                                    ),
                                    onPressed: () {
                                      FlutterPhoneDirectCaller.callNumber('+94763088444');
                                    },
                                    child: ListTile(
                                      leading: Icon(Icons.account_circle),
                                      title: Text("BENERT"),
                                      trailing: Icon(Icons.call),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromRGBO(153, 255, 153, 1.0), // Change the button color here
                                    ),
                                    onPressed: () {
                                      FlutterPhoneDirectCaller.callNumber('+94763088444');
                                    },
                                    child: ListTile(
                                      leading: Icon(Icons.account_circle),
                                      title: Text("BENERT"),
                                      trailing: Icon(Icons.call),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                ),

              )
          ),
        );
      },
    );
  }

  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(6.9271, 79.8612), zoom: 14);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2FEFE),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.keyboard_voice_rounded)
        ],
        color: mainThemeColor,
        backgroundColor: Colors.transparent,
        height: 60,
      ),
      appBar: AppBar(
        backgroundColor: mainThemeColor,
        title: const Text(
          "Emergency",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins'
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition:initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal, onMapCreated: (GoogleMapController controller){
        googleMapController = controller;
      },),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {

          showBottomSheet(context);


          Position position = await _determinePosition();

          googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude,position.longitude),zoom: 14)));

          markers.clear();

          markers.add(Marker(markerId: const MarkerId("currentLocation"),position: LatLng(position.latitude,position.longitude)));

          setState(() {});

        },
        backgroundColor: Color.fromRGBO(153, 255, 153, 1.0),
        label: Text("Enable Emergency Situation"),
      ),
    );
  }




  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

}




