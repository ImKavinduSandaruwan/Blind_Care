
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectblindcare/screens/registration_screen.dart';
import '../constants/constant.dart';
import 'emergency_screen.dart';
import 'home_screen.dart';
import 'logging_screen.dart';

class log_reg extends StatefulWidget {
  const log_reg({super.key});

  @override
  State<log_reg> createState() => _log_regState();
}

class _log_regState extends State<log_reg> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(

      backgroundColor: const Color(0xffF2FEFE),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(75,179,154, 1.0),
        title: const Text(
          "Blind care",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
      body: Container(
        width: screenWidth,
        // height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            ElevatedButton(
                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Logging()));},
                child: Text('Logging',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                // padding: EdgeInsets.all(16.0),
                fixedSize: Size(screenWidth*0.9,50.0),
                backgroundColor: Color.fromRGBO(75,179,154, 1.0),
                foregroundColor: Color.fromRGBO(0, 0, 0 ,1.0),

              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));},
                child: Text('Register',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                fixedSize: Size(screenWidth*0.9, 50.0),
                backgroundColor: Color.fromRGBO(224, 247, 213, 1.0),
                foregroundColor: Color.fromRGBO(0, 0, 0 ,1.0),
                // side: BorderSide(
                //   color: Color.fromRGBO(153, 255, 153, 1.0), // Set the border color
                //   width: 5.0, // Set the border width
                // ),
              ),
            ),
            SizedBox(
              height: 80.0,
            ),

          ],
        ),
      ),
    );
  }
}
