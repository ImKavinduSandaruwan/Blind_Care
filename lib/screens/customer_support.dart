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
    );
  }
}