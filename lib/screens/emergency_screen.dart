import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectblindcare/constants/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projectblindcare/screens/emergency_settings_screen.dart';
import 'package:projectblindcare/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


import '../main.dart';

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

bool contactLoaded = false;

String msgOrCall = "";

double latitude = 0.00;
double longitude = 0.00;


class _emergencyFeature extends State<EmergencyScreen> {

  final _fireStore = FirebaseFirestore.instance;

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

  void showBottomSheetForCurrentLocationSharing(BuildContext context) {
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
                    Text("Chose the person",style: TextStyle(fontSize: 28,fontFamily:'Arial',fontWeight: FontWeight.bold)),
                    // Container(
                    //   width: screenWidth,
                    //   height: screenHeight * 0.25,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Text("Chose the person",style: TextStyle(fontSize: 28,fontFamily:'Arial',fontWeight: FontWeight.bold)),
                    //       // Text("Want to contact someone?",style: TextStyle(fontSize: 24,fontFamily:'Arial',fontWeight: FontWeight.bold)),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      // color: Colors.cyan,

                      child: Column(
                        children: [
                          Text("Contact List",style: TextStyle(fontSize: 22,fontFamily:'Arial')),
                          Container(
                            height: screenHeight * 0.35,
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

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
        title: Text(
          """Emergency""",
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
            onPressed: () async {
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
      floatingActionButton:
      // Column(
      //   children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight*0.2),
              Center(
                child: Container(
                  width: screenWidth*0.9,
                  height: screenHeight*0.1,
                  // margin: EdgeInsets.only(top: 100.0),
                  child:
                  FloatingActionButton.extended(

                    onPressed: () async {

                      msgOrCall = "msg";

                      // if(contactLoaded == false){
                      //   EmergencyCantactListHandler handler = EmergencyCantactListHandler();
                      //   // Load contacts
                      //   List<ContactDataModel> contacts = await handler.loadContacts();
                      //
                      //   // Do something with the loaded contacts
                      //   for (ContactDataModel contact in contacts) {
                      //     print('Name: ${contact.name}, Phone: ${contact.phoneNumber}');
                      //     EmergencyCantactListHandler.addDynamicWidget('${contact.name}', '${contact.phoneNumber}');
                      //   }
                      //
                      //   contactLoaded = true;
                      // }


                      Position position = await _determinePosition();

                      googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude,position.longitude),zoom: 14)));

                      markers.clear();

                      markers.add(Marker(markerId: const MarkerId("currentLocation"),position: LatLng(position.latitude,position.longitude)));

                      latitude = position.latitude;
                      longitude = position.longitude;

                      showBottomSheetForCurrentLocationSharing(context);

                      setState(() {});



                    },
                    backgroundColor: Color.fromRGBO(153, 255, 153, 1.0),
                    label: Text("Share current location"),
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.1),
              Center(
                child: Container(
                  width: screenWidth*0.9,
                  height: screenHeight*0.1,
                  // margin: EdgeInsets.only(top: 100.0),
                  child:
                  FloatingActionButton.extended(

                    onPressed: () async {

                      msgOrCall = "call";

                      showBottomSheet(context);

                    },
                    backgroundColor: Color.fromRGBO(153, 255, 153, 1.0),
                    label: Text("Enable Emergency Situation"),
                  ),
                ),
              ),
            ],
          ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,



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

  late Map<String, dynamic> myMap;


  static void addDynamicWidget(String name,String phone) {
    _emergencyFeature.dynamicWidgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ElevatedButton(
            style:ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(153, 255, 153, 1.0),
            ) ,
            onPressed: () async {
              if(msgOrCall == "call"){
                FlutterPhoneDirectCaller.callNumber(phone);
              }else if(msgOrCall == "msg"){

                final Uri smsLaunchUri = Uri(
                  scheme: 'sms',
                  path: phone,
                  queryParameters: <String, String>{
                    'body': Uri.encodeComponent('Hey $name, I am in emergency situation. This is my current Location: https://maps.google.com/?q=$latitude,$longitude'),
                  },
                );

                if(await canLaunchUrl(smsLaunchUri)){
                  await launchUrl(smsLaunchUri);
                }else{
                  print("hello hello");
                }

              }
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


  static Future<void> saveMap(String key, Map map) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert the map to a JSON string before storing
    prefs.setString(key, json.encode(map));
  }

  static Future<Map<String, dynamic>?> loadMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    // Convert the JSON string back to a map
    return jsonString != null ? json.decode(jsonString) : null;
  }

  sendDataToFirestore(String name, String phone) {
    FirebaseFirestore.instance.collection('Contacts').add({
      'name': name,
      'phone': phone
    });
  }

  static Future<List<Map<String, dynamic>>> fetchDataFromFirestore() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Contacts').get();

      List<Map<String, dynamic>> contacts = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
      in querySnapshot.docs) {
        contacts.add(documentSnapshot.data());
      }

      return contacts;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }


  // static getDataFromFirestore() async {
  //   try {
  //     // Get the collection reference
  //     final QuerySnapshot<Map<String, dynamic>> data =
  //         await FirebaseFirestore.instance.collection('EmgContacts').get();
  //
  //     // Process the documents in the snapshot
  //     for (var contact in data.docs) {
  //       // Access the data using contact.data()
  //       Map<String, dynamic> contactData = contact.data();
  //       // Now you can use contactData as needed
  //       print(contactData);
  //     }
  //   } catch (error) {
  //     // Handle any errors that occurred during the process
  //     print("Error fetching data: $error");
  //   }
  // }
  

}
//
// class ContactDataModel{
//   String? name;
//   String? phoneNumber;
//
//   ContactDataModel(
//       {
//         this.name,
//         this.phoneNumber
//       });
//
//   ContactDataModel.fromJson(Map<String,dynamic> json){
//     name = json['name'];
//     phoneNumber = json['phoneNumber'];
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'phoneNumber': phoneNumber,
//     };
//   }
// }
//
//
// class Person {
//   String name;
//   String phoneNumber;
//
//   Person({required this.name, required this.phoneNumber});
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'phoneNumber': phoneNumber,
//     };
//   }
//
//   factory Person.fromMap(Map<String, dynamic> map) {
//     return Person(
//       name: map['name'],
//       phoneNumber: map['phoneNumber'],
//     );
//   }
//
//   static Future<void> savePerson(Person person) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> peopleData = prefs.getStringList('people') ?? [];
//
//     // Convert the Person object to a map and add it to the list
//     peopleData.add(json.encode(person.toMap()));
//
//     // Save the updated list to SharedPreferences
//     prefs.setStringList('people', peopleData);
//   }
//
//
//   static Future<List<Person>> loadPeople() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> peopleData = prefs.getStringList('people') ?? [];
//
//     // Convert each JSON string back to a map and then to a Person object
//     List<Person> people = peopleData.map((jsonString) {
//       Map<String, dynamic> map = json.decode(jsonString);
//       return Person.fromMap(map);
//     }).toList();
//
//     return people;
//   }
//
// }

