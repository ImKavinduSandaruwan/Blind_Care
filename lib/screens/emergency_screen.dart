import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectblindcare/constants/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projectblindcare/screens/emergency_settings_screen.dart';
import 'package:projectblindcare/screens/home_screen.dart';
import 'package:flutter/services.dart' as rootBundle;



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
      floatingActionButton: Container(
        width: screenWidth*0.9,
        height: screenHeight*0.1,
        margin: EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton.extended(
          onPressed: () async {

            if(contactLoaded == false){
              EmergencyCantactListHandler handler = EmergencyCantactListHandler();
              // Load contacts
              List<ContactDataModel> contacts = await handler.loadContacts();

              // Do something with the loaded contacts
              for (ContactDataModel contact in contacts) {
                print('Name: ${contact.name}, Phone: ${contact.phoneNumber}');
                EmergencyCantactListHandler.addDynamicWidget('${contact.name}', '${contact.phoneNumber}');
              }

              contactLoaded = true;
            }

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

  // static void readJsonData() async {
  //   final jsonData =  await rootBundle.rootBundle.loadString('contactStorage/EmergencyContactStorage.json');
  //   final list = json.decode(jsonData) as List<dynamic>;
  //
  //   List<ContactDataModel> contactList = list.map((e) => ContactDataModel.fromJson(e)).toList();
  //
  //   print(list.length);
  //
  //   for (var contact in contactList) {
  //     EmergencyCantactListHandler.addDynamicWidget("${contact.name}", "${contact.phoneNumber}");
  //   }
  // }

  static void addContact(ContactDataModel newContact) async {
    // Get the documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Specify the file path within the documents directory
    String filePath = '${documentsDirectory.path}/EmergencyContactStorage.json';

    try {
      // Check if the file exists, create it if not
      File file = File(filePath);
      if (!file.existsSync()) {
        file.createSync();
      }

      // Read existing JSON data from the file
      String existingData = file.readAsStringSync();

      // Parse JSON data into a List<dynamic>
      List<dynamic> existingList = (existingData.isNotEmpty)
          ? jsonDecode(existingData)
          : <dynamic>[];

      // Add the new contact to the list
      existingList.add(newContact.toJson());


      // existingList.clear();

      // Convert the updated list back to JSON
      String updatedData = jsonEncode(existingList);

      // Write the updated JSON data back to the file
      file.writeAsStringSync(updatedData);

      print('Contact added successfully.');

      String contentAfterWrite = file.readAsStringSync();
      print('😇 Content after write: $contentAfterWrite');
    } catch (e) {
      print('😘 Error adding contact: $e');
    }
  }

  Future<List<ContactDataModel>> loadContacts() async {
    // Get the documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Specify the file path within the documents directory
    String filePath = '${documentsDirectory.path}/EmergencyContactStorage.json';

    try {
      // Read existing JSON data from the file
      String existingData = File(filePath).readAsStringSync();

      // Parse JSON data into a List<ContactDataModel>
      List<dynamic> existingList = (existingData.isNotEmpty)
          ? jsonDecode(existingData)
          : <dynamic>[];

      List<ContactDataModel> contacts = existingList
          .map((contactJson) => ContactDataModel.fromJson(contactJson))
          .toList();

      return contacts;
    } catch (e) {
      print('😘 Error loading contacts: $e');
      return <ContactDataModel>[]; // Return an empty list in case of an error
    }
  }

}

class ContactDataModel{
  String? name;
  String? phoneNumber;

  ContactDataModel(
      {
        this.name,
        this.phoneNumber
      });

  ContactDataModel.fromJson(Map<String,dynamic> json){
    name = json['name'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}

