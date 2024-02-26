import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projectblindcare/components/camera_view.dart';
import '../components/scan_controller.dart';
import '../constants/constant.dart';
import 'package:camera/camera.dart';

class ObjectDetection extends StatefulWidget {
  const ObjectDetection({super.key});

  @override
  State<ObjectDetection> createState() => _ObjectDetectionState();
}

class _ObjectDetectionState extends State<ObjectDetection> {

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
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
      /// App is optional.🤔🤔
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
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: const Color(0xffC5C5C5),
                width: 2
            )
        ),
        width: 400,
        height: 400,
        child: Column(
          children: [
            Container(
                width: 200,
                height: 200,
                child: CameraView()),
            Container(
                width: 100,
                height: 100,
                child: Obx(() => Text(Get.find<ScanController>().detectionResult.value))),
          ],
        ),
      ),
    );
  }
}
