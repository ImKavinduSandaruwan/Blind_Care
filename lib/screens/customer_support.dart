import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:projectblindcare/constants/constant.dart';

import '../components/square_tile.dart';
import '../services/auth_service.dart';

class CustomerService extends StatefulWidget {
  const CustomerService({super.key});

  @override
  State<CustomerService> createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void google() {
    print("google");
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
      bottomNavigationBar: CurvedNavigationBar(
        items: const [Icon(Icons.keyboard_voice_rounded)],
        color: mainThemeColor,
        backgroundColor: Colors.white,
        height: 60,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //TODO: Implement other functionalities
          Expanded(
            flex: 3,
            child: Container(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      Expanded(
                        child: SquareTile(
                          imagePath: "images/apple.png",
                          onTap: google,
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
}