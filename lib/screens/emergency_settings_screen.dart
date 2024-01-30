import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
          Icon(Icons.keyboard_voice_rounded)
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
              fontFamily: 'Poppins'
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Contact List",style: TextStyle(fontSize: 28,color: Colors.black,fontFamily:'Arial',fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight*0.6,
                  // color: Colors.grey,
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: screenWidth*0.9,
                                    child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                                    color: Color.fromRGBO(203, 255, 211, 1),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: screenWidth*0.9,
                                    child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                                    color: Color.fromRGBO(203, 255, 211, 1),

                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      color: mainThemeColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                      ),
                                    child: IconButton(
                                      onPressed: (){
                                        openDialogBox(context);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                      ),
                                    ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: screenWidth*0.9,
                                    child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                                    color: Color.fromRGBO(203, 255, 211, 1),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: screenWidth*0.9,
                                    child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                                    color: Color.fromRGBO(203, 255, 211, 1),

                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      color: mainThemeColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    child: IconButton(
                                      onPressed: (){},
                                      icon: Icon(
                                        Icons.edit,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: screenWidth*0.9,
                                    child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                                    color: Color.fromRGBO(203, 255, 211, 1),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: screenWidth*0.9,
                                    child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                                    color: Color.fromRGBO(203, 255, 211, 1),

                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      color: mainThemeColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    child: IconButton(
                                      onPressed: (){},
                                      icon: Icon(
                                        Icons.edit,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: screenWidth*0.9,
                                    child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                                    color: Color.fromRGBO(203, 255, 211, 1),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: screenWidth*0.9,
                                    child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                                    color: Color.fromRGBO(203, 255, 211, 1),

                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      color: mainThemeColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    child: IconButton(
                                      onPressed: (){},
                                      icon: Icon(
                                        Icons.edit,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],

                  )
                ),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Color.fromRGBO(153, 255, 153, 1.0),
        label: Icon(Icons.add),
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

  // Future openDialogBox(BuildContext context) => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text("Contact 1"),
  //       content: Container(
  //         child: Column(
  //           children: [
  //             TextField(
  //               decoration: InputDecoration(hintText: 'Ginura'),
  //             ),
  //             TextField(
  //               decoration: InputDecoration(hintText: 'Ginura'),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //             onPressed: (){
  //
  //             },
  //             child: Text("Done"))
  //       ],
  //     )
  // );

}

