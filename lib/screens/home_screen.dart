import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:projectblindcare/constants/constant.dart';
import 'package:projectblindcare/screens/object_detection.dart';
import 'package:projectblindcare/components/reuseble_FunctionCard.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:projectblindcare/screens/poi.dart';
import 'customer_support.dart';
import 'emergency_screen.dart';
import 'navigation_maps.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ///Implementing alan AI
  _HomeScreenState() {
    AlanVoice.addButton("297ec570615d4f747742b6798d22577d2e956eca572e1d8b807a3e2338fdd0dc/stage");
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch(command["command"]) {
      case "police":
        FlutterPhoneDirectCaller.callNumber("0703088444");
        break;
      case "call contacts":
        var NAME = command["text"];
        print('name name $NAME');

        if (EmergencyCantactListHandler.contactsMap.containsKey(NAME)) {
          String? NAMEphone = EmergencyCantactListHandler.contactsMap[NAME];
          print(NAMEphone);
          FlutterPhoneDirectCaller.callNumber("$NAMEphone");
        } else {
          print("Key does not exist in the map.");
        }
        break;

      case "location":
        var NAMEMSG = command["text"];
        print('name name $NAMEMSG');

        if (EmergencyCantactListHandler.contactsMap.containsKey(NAMEMSG)) {
          String? NAMEmsg = EmergencyCantactListHandler.contactsMap[NAMEMSG];
          print(NAMEmsg);

          EmergencyCantactListHandler.sendMsg(NAMEMSG, NAMEmsg);
        }
        break;
    }

  }

  ///Navigating to the Blind Map
  void navigateToTheMap(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ObjectDetection()));
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
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
      body: Container(
        child: Column(
          children: [
            /// This expand widget contains image, text and stuff
            Expanded(
              child: Container(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Positioned(
                      top: -screenHeight * 0.08,
                      right: screenWidth * 0.69,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: fadedRoundColors,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -screenWidth * 0.29,
                      right: screenWidth * 0.49,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: fadedRoundColors,
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Blind Care',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 30,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      'Set Your Destination',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 20,
                                          letterSpacing: 4
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.sunny,size: 30,color: Colors.yellow,)
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Image(
                                width: screenWidth,
                                image: AssetImage("images/blind.png"),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /// This expand widget contains function buttons
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          FunctionCard("images/map.png","Blind Map",(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LocationMap()));
                          }),
                          FunctionCard("images/poi.png","Place Of Interests",(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceOfInterests()));
                          }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          FunctionCard("images/emergency.png","Emergency",(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                            /// Add navigation route for emergency page
                          }),
                          FunctionCard("images/service.png","Help Center",(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerService()));
                            /// Add navigation route for help center page
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
