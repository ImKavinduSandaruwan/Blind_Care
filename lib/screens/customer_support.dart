import 'package:cloud_firestore/cloud_firestore.dart';
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

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.arrow_back_sharp),
                SizedBox(width: 10,),
                Text("Customer Support"),
              ],
            ),
            Icon(Icons.support_agent_sharp)
          ],
        ),
        backgroundColor: mainThemeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Image(
                width: 300,
                height: 300,
                image: AssetImage('images/service.png'),
              ),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Send Feedback',
                border: OutlineInputBorder(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _textController.clear(); // Correctly using a function here
                  },
                  child: Icon(Icons.clear),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}