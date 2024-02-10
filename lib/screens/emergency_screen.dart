import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projectblindcare/constants/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projectblindcare/screens/emergency_settings_screen.dart';
import 'package:projectblindcare/screens/home_screen.dart';



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

  static List<Widget> dynamicWidgets = [];

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        return Container(
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child:Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Emergency handling",style: TextStyle(fontSize: 28,fontFamily:'Arial',fontWeight: FontWeight.bold)),
                          // Text("Want to contact someone?",style: TextStyle(fontSize: 24,fontFamily:'Arial',fontWeight: FontWeight.bold)),
                          Text("Contact nearest police station",style: TextStyle(fontSize: 22,fontFamily:'Arial')),
                          ElevatedButton(
                              onPressed: (){
                                FlutterPhoneDirectCaller.callNumber('+94703088444');
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
                      // color: Colors.cyan,

                      child: Column(
                        children: [
                          Text("Contact List",style: TextStyle(fontSize: 22,fontFamily:'Arial')),
                          Container(
                            height: screenHeight * 0.15,
                            child: ListView(
                              children: dynamicWidgets,
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencySettingsScreen()));
              print('Settings button pressed');
            },
          ),
        ],
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

class EmergencyCantactListHandler {
  static void addDynamicWidget(String name,String phone) {
    _emergencyFeature.dynamicWidgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ElevatedButton(
            style:ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(153, 255, 153, 1.0),
            ) ,
            onPressed: (){
              FlutterPhoneDirectCaller.callNumber(phone);
            },
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(name),
              trailing: Icon(Icons.call),
            ),
          ),
        ),
      )
    );
  }
}

