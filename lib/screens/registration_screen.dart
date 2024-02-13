
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectblindcare/screens/log_reg_screen.dart';
import '../constants/constant.dart';
import 'emergency_screen.dart';
import 'emergency_settings_screen.dart';
import 'home_screen.dart';





class Registration extends StatefulWidget {
  const Registration({super.key});



  @override
  State<Registration> createState() => _registration_State();
}

class _registration_State extends State<Registration> {

  late String email;
  late String password;


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      backgroundColor: const Color(0xffF2FEFE),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(224, 247, 213, 1.0),
        title: const Text(
          "Create an account",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => log_reg()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          // height: screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50.0,
              ),
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset('images/applogo.jpeg'),
                  height: 200.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: screenWidth*0.9,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value){
                    email = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'ginura@gmail.com', // Placeholder text
                    labelText: 'Enter e-mail', // Label text
                    prefixIcon: Icon(Icons.person), // Prefix icon
                    suffixIcon: Icon(Icons.clear), // Suffix icon
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(224, 247, 213, 1.0), width: 4.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    // You can customize other properties as needed
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: screenWidth*0.9,
                child: TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value){
                    password = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'At least 6 digits should be included', // Placeholder text
                    labelText: 'Enter password', // Label text
                    prefixIcon: Icon(Icons.person), // Prefix icon
                    suffixIcon: Icon(Icons.clear), // Suffix icon
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(224, 247, 213, 1.0), width: 4.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    // You can customize other properties as needed
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: (){
                  print(email);
                  print(password);
                },
                child: Text('Create account',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  // padding: EdgeInsets.all(16.0),
                  fixedSize: Size(screenWidth*0.9,50.0),
                  backgroundColor: Color.fromRGBO(224, 247, 213, 1.0),
                  foregroundColor: Color.fromRGBO(0, 0, 0 ,1.0),

                ),
              ),
              // SizedBox(
              //   height: 50.0,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
