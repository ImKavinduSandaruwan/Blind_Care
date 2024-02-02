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
          child: Center(
            child: Container(
              width: screenWidth*0.9,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Contact List",style: TextStyle(fontSize: 28,color: Colors.black,fontFamily:'Arial',fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0,top: 8.0,right: 0.0,bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      width: screenWidth,
                      // height: screenHeight*0.6,
                      // color: Colors.grey,
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                    child: Icon(Icons.account_circle),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                    child: Text("Ginura"),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                    child: Icon(Icons.phone),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                    child: Text("+94703088444"),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                            color: Colors.red,
                          onPressed: (){},
                        ),

                        onTap: (){
                          openDialogBox(context);
                        },
                      )

                      // ListView(
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Container(
                      //           child: Column(
                      //             children: [
                      //               Padding(
                      //                 padding: const EdgeInsets.all(4.0),
                      //                 child: Container(
                      //                   width: screenWidth*0.9,
                      //                   child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                      //                   color: Color.fromRGBO(203, 255, 211, 1),
                      //                 ),
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.all(4.0),
                      //                 child: Container(
                      //                   width: screenWidth*0.9,
                      //                   child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                      //                   color: Color.fromRGBO(203, 255, 211, 1),
                      //
                      //                 ),
                      //               ),
                      //               ElevatedButton.icon(
                      //                   onPressed: (){openDialogBox(context);},
                      //                   icon: Icon(Icons.edit),
                      //                 style: ElevatedButton.styleFrom(
                      //                   backgroundColor: Colors.grey
                      //                 ),
                      //                   label: Text("Edit"),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      //
                      // )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0,top: 8.0,right: 0.0,bottom: 8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        width: screenWidth,
                        // height: screenHeight*0.6,
                        // color: Colors.grey,
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Icon(Icons.account_circle),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Text("Ginura"),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Icon(Icons.phone),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Text("+94703088444"),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: (){},
                          ),

                          onTap: (){
                            openDialogBox(context);
                          },
                        )

                      // ListView(
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Container(
                      //           child: Column(
                      //             children: [
                      //               Padding(
                      //                 padding: const EdgeInsets.all(4.0),
                      //                 child: Container(
                      //                   width: screenWidth*0.9,
                      //                   child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                      //                   color: Color.fromRGBO(203, 255, 211, 1),
                      //                 ),
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.all(4.0),
                      //                 child: Container(
                      //                   width: screenWidth*0.9,
                      //                   child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                      //                   color: Color.fromRGBO(203, 255, 211, 1),
                      //
                      //                 ),
                      //               ),
                      //               ElevatedButton.icon(
                      //                   onPressed: (){openDialogBox(context);},
                      //                   icon: Icon(Icons.edit),
                      //                 style: ElevatedButton.styleFrom(
                      //                   backgroundColor: Colors.grey
                      //                 ),
                      //                   label: Text("Edit"),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      //
                      // )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0,top: 8.0,right: 0.0,bottom: 8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        width: screenWidth,
                        // height: screenHeight*0.6,
                        // color: Colors.grey,
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Icon(Icons.account_circle),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Text("Ginura"),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Icon(Icons.phone),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Text("+94703088444"),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: (){},
                          ),

                          onTap: (){
                            openDialogBox(context);
                          },
                        )

                      // ListView(
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Container(
                      //           child: Column(
                      //             children: [
                      //               Padding(
                      //                 padding: const EdgeInsets.all(4.0),
                      //                 child: Container(
                      //                   width: screenWidth*0.9,
                      //                   child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                      //                   color: Color.fromRGBO(203, 255, 211, 1),
                      //                 ),
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.all(4.0),
                      //                 child: Container(
                      //                   width: screenWidth*0.9,
                      //                   child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                      //                   color: Color.fromRGBO(203, 255, 211, 1),
                      //
                      //                 ),
                      //               ),
                      //               ElevatedButton.icon(
                      //                   onPressed: (){openDialogBox(context);},
                      //                   icon: Icon(Icons.edit),
                      //                 style: ElevatedButton.styleFrom(
                      //                   backgroundColor: Colors.grey
                      //                 ),
                      //                   label: Text("Edit"),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      //
                      // )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0,top: 8.0,right: 0.0,bottom: 8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        width: screenWidth,
                        // height: screenHeight*0.6,
                        // color: Colors.grey,
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Icon(Icons.account_circle),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Text("Ginura"),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Icon(Icons.phone),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                                      child: Text("+94703088444"),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: (){},
                          ),

                          onTap: (){
                            openDialogBox(context);
                          },
                        )

                      // ListView(
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Container(
                      //           child: Column(
                      //             children: [
                      //               Padding(
                      //                 padding: const EdgeInsets.all(4.0),
                      //                 child: Container(
                      //                   width: screenWidth*0.9,
                      //                   child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                      //                   color: Color.fromRGBO(203, 255, 211, 1),
                      //                 ),
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.all(4.0),
                      //                 child: Container(
                      //                   width: screenWidth*0.9,
                      //                   child: Center(child: Text("Person 1",style: TextStyle(fontSize: 22,fontFamily:'Arial'))),
                      //                   color: Color.fromRGBO(203, 255, 211, 1),
                      //
                      //                 ),
                      //               ),
                      //               ElevatedButton.icon(
                      //                   onPressed: (){openDialogBox(context);},
                      //                   icon: Icon(Icons.edit),
                      //                 style: ElevatedButton.styleFrom(
                      //                   backgroundColor: Colors.grey
                      //                 ),
                      //                   label: Text("Edit"),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      //
                      // )
                    ),
                  ),
                ],
              ),
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



}

