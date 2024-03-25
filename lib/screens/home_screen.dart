import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:projectblindcare/constants/constant.dart';
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
    /// Initializes the Alan AI button with a specific project ID.
    /// This enables voice interaction within the app using Alan AI's capabilities.
    /// The project ID is used to connect the app to the corresponding Alan AI project.
    AlanVoice.addButton("72c64715b451423bf6ac4a0ab4e8c0ba2e956eca572e1d8b807a3e2338fdd0dc/stage");
    /// Adds a command handler to process commands received from the Alan AI dialog script.
    /// This handler is triggered when a command is sent from the dialog script, allowing the app to respond accordingly.
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  /// Handles various commands received from the Alan AI dialog script.
  /// Each command triggers a specific action within the app.
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
      case "poi":
        executePoi();
        break;
    }

  }

  /// Navigates to the PlaceOfInterests screen.
  /// This function is called when the "poi" command is received from the Alan AI dialog script.
  /// It uses the Navigator.push method to transition to the PlaceOfInterests screen,
  /// which is expected to display points of interest relevant to the user.
  void executePoi(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceOfInterests()));
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF2FEFE),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyScreen()));
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