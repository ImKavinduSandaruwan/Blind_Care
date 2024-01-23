import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../constants/constant.dart';

class ObjectDetection extends StatefulWidget {
  const ObjectDetection({super.key});

  @override
  State<ObjectDetection> createState() => _ObjectDetectionState();
}

class _ObjectDetectionState extends State<ObjectDetection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2FEFE),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.keyboard_voice_rounded)
        ],
        color: mainThemeColor,
        backgroundColor: Colors.white,
        height: 60,
      ),
      appBar: AppBar(
        backgroundColor: mainThemeColor,
        title: const Text(
          "Navigation",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins'
          ),
        ),
      ),
    );
  }
}
