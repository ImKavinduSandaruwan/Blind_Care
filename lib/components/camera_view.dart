import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:projectblindcare/components/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  /// Builds the UI for the camera preview screen.
  ///
  /// This method uses the GetBuilder widget to manage the state of the camera preview.
  /// It checks if the camera has been initialized (`controller.isCameraInitialized.value`).
  /// If the camera is initialized, it displays the `CameraPreview` widget using the camera controller.
  /// Otherwise, it shows a centered "Loading..." text message to indicate that the camera is still initializing.
  ///
  /// The GetBuilder widget is used to efficiently rebuild the UI when the camera initialization state changes.
  /// This ensures that the camera preview is displayed as soon as the camera is ready, and the loading message
  /// is shown while the camera is initializing.
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
