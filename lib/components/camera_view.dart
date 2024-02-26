import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:projectblindcare/components/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanController>(
      init: ScanController(),
      builder: (controller) {
        return controller.isCameraInitialized.value
            ? CameraPreview(controller.cameraController)
            : Center(child: Text("Loading..."));
      }
    );
  }
}
