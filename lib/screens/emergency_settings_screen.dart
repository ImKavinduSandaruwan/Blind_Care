
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projectblindcare/constants/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projectblindcare/screens/emergency_screen.dart';
import 'package:projectblindcare/screens/home_screen.dart';





class EmergencySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: const Color(0xffF2FEFE),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.keyboard_voice_rounded),
        ],
        color: mainThemeColor,
        backgroundColor: Colors.transparent,
        height: 60,
      ),
      appBar: AppBar(
        backgroundColor: mainThemeColor,
        title: const Text(
          "Emergency Settings",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
      ),
      body: FutureBuilder(
        future: getContacts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: SizedBox(height: 50, child: CircularProgressIndicator()),
            );
          }
          return Container(
            width: screenWidth, // Set appropriate width
            height: screenHeight, // Set appropriate height
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Contact contact = snapshot.data[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children:<Widget> [
                            Row(

                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                  child: Icon(Icons.account_circle),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                  child: Text(contact.displayName),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                  child: Icon(Icons.phone),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                  child: Text(contact.phones[0].number),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      trailing:  IconButton(
                        icon: Icon(Icons.emergency),
                        color: Colors.red,
                        onPressed: (){
                          EmergencyCantactListHandler.addDynamicWidget(contact.displayName,contact.phones[0].number);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }


  Future openDialogBox(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Contact 1"),
        content: Container(
          height: 100, // Set the desired height
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Ginura'),
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13), // +94 and 10 digits
                ],
                onSubmitted: (_) => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("Done")
          )
        ],
      )
  );

  Future<List<Contact>> getContacts() async {

    bool isGranted = await Permission.contacts.status.isGranted;

    if(!isGranted){
      isGranted = await Permission.contacts.request().isGranted;
    }

    if(isGranted){
      return await FastContacts.getAllContacts();
    }
    return [];
  }



}

