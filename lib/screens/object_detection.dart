import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projectblindcare/components/camera_view.dart';
import '../components/scan_controller.dart';
import '../constants/constant.dart';
import 'package:camera/camera.dart';

class ObjectDetectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp for GetX functionality
      home: ObjectDetection(),
    );
  }
}


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
    return Container(
        child: Column(
          children: [
            Container(
                width: screenWidth/2,
                height: screenHeight/2,
                child: CameraView()),
            Container(
                width: screenWidth,
                height: screenHeight/2,
                child: Obx(() => Text(Get.find<ScanController>().detectionResult.value))
            ),
          ],
        ),
    );
  }
}
