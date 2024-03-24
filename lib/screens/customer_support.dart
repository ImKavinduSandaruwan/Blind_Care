import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projectblindcare/constants/constant.dart';

import '../components/square_tile.dart';
import '../services/auth_service.dart';

class CustomerService extends StatefulWidget {
  const CustomerService({super.key});

  @override
  State<CustomerService> createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {


  void sendDataToFirestore() {
    FirebaseFirestore.instance.collection('ginura testing1').add({
      'text': 'data added',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainThemeColor,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Help Desk"),
            Icon(Icons.support_agent_sharp),
          ],
        ),
      ),
      backgroundColor: const Color(0xffF2FEFE),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //TODO: Implement other functionalities
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: sendDataToFirestore,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.red,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ///Getting touch with us
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 2.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Getting Touch With Us"),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),

                  ///Google and Apple sign in Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///Google Button
                      Expanded(
                        child: SquareTile(
                          imagePath: "images/google.png",
                          onTap: () async {
                            await AuthService().signWithGoogleAccount();
                          },
                        ),
                      ),
                      const SizedBox(width: 20,),
                      ///Apple Button
                      //TODO : Need to implement Apple sign in function
                      Expanded(
                        child: SquareTile(
                          imagePath: "images/apple.png",
                          onTap: (){},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user?.displayName);


  }

}