
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:projectblindcare/constants/constant.dart';
import 'package:projectblindcare/screens/emergency_screen.dart';


class EmergencySettingsScreen extends StatefulWidget {
  const EmergencySettingsScreen({super.key});

  @override
  State<EmergencySettingsScreen> createState() => _EmergencySettingsScreenState();
}



class _EmergencySettingsScreenState extends State<EmergencySettingsScreen> {

  List<Widget> addedContacts = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();


  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dialog Title'),
          content: Container(
            constraints: BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: 'Enter Text 1'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(hintText: 'Enter Text 2'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                EmergencyCantactListHandler.addDynamicWidget(nameController.text, phoneNumberController.text);
                _addedSavedContact(nameController.text,phoneNumberController.text);
                nameController.clear();
                phoneNumberController.clear();
                Navigator.of(context).pop();
                setState(() {
                  addedContacts;
                });
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _addedSavedContact(String name, String phone){
    addedContacts.add(
        Container(
          margin: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: mainThemeColor, // Set the color of the border
              width: 2.0,           // Set the width of the border
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),  // Set border radius if you want rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget> [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                          child: Icon(Icons.account_circle),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0,top: 0,right: 8.0,bottom: 0),
                          child: Text(name),
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
                          child: Text(phone),
                        ),
                      ],
                    )
                  ],
                ),
                IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.delete)
                )
              ],
            ),
          ),
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF2FEFE),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [Icon(Icons.keyboard_voice_rounded)],
        color: mainThemeColor,
        backgroundColor: Colors.transparent,
        height: 60,
      ),
      appBar: AppBar(
        backgroundColor: mainThemeColor,
        title: const Text(
          "Emergency Settings",
          style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: addedContacts,
                  )
              ),

              Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                height: 60.0,
                width: screenWidth * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    _showDialog(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(153, 255, 153, 1.0)),
                  ),
                  child: Text("ADD",style: TextStyle(color: Colors.black,fontSize: 30,fontFamily:'Arial',fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
