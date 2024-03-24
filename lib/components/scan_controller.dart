import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTlLite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var detectionResult = "".obs;


  /// Initializes the camera and starts an image stream for object detection.
  ///
  /// This function first requests camera permission. If granted, it initializes the
  /// camera controller with the first available camera and a high resolution preset.
  /// It then starts an image stream, incrementing a counter (`cameraCount`) with
  /// each frame. Every 10th frame, it resets the counter and calls `objectDetector`
  /// with the current image for object detection. This process continues until the
  /// camera is disposed or the stream is stopped.
  ///
  /// If camera permission is denied, it prints 'access denied' to the console.
  ///
  /// Note: Ensure that the `objectDetector` function is implemented to handle the
  /// image data for object detection.
  initCamera()async{
    if(await Permission.camera.request().isGranted){
      cameras = await availableCameras();
      cameraController = CameraController(
          cameras[0],
          ResolutionPreset.high
      );
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if(cameraCount % 10 == 0){
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized(true);
      update();
    }else{
      print('access denied');
    }
  }

  /// Initializes the TensorFlow Lite model for object detection.
  ///
  /// This function loads a pre-trained TensorFlow Lite model (`blind-care.tflite`) and its
  /// corresponding label file (`blind-care.txt`) from the app's assets. The model is loaded
  /// with a single thread for inference and without using the GPU delegate for performance
  /// reasons. This setup is suitable for devices with limited GPU capabilities or when
  /// the model's performance is sufficient without GPU acceleration.
  ///
  /// Note: Ensure that the model and label files are correctly placed in the `assets`
  /// directory and that the `assets` section in `pubspec.yaml` is updated to include these
  /// files. This is necessary for the app to access the model and labels at runtime.
  initTlLite() async {
    await Tflite.loadModel(
        model: "assets/blind-care.tflite",
        labels: "assets/blind-care.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false
    );
  }

  /// Processes camera frames using a TensorFlow Lite model for object detection.
  ///
  /// This function takes a `CameraImage` object as input, which represents a frame captured
  /// by the camera. It then runs the TensorFlow Lite model on this frame to detect objects.
  /// The model is configured to process the frame with a high resolution, using a mean and
  /// standard deviation of 127.5 for image normalization. The image is rotated by 90 degrees
  /// to match the orientation of the camera image. The function is set to return results
  /// asynchronously (`asynch: true`) for performance reasons.
  ///
  /// The detected objects are filtered based on a threshold of 0.8, meaning only objects with
  /// a confidence score above this threshold are considered valid detections. The function
  /// prints the detection results and updates a `detectionResult` value with the label of the
  /// detected object.
  ///
  /// Note: Ensure that the TensorFlow Lite model (`blind-care.tflite`) and its corresponding
  /// label file (`blind-care.txt`) are correctly loaded and configured before calling this function.
  objectDetector(CameraImage cameraImage) async{
    var detector = await Tflite.runModelOnFrame(
        bytesList: cameraImage.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.8,
        asynch: true
    );
    if(detector != null){
      print("😂😂😂😂😂😂😂 $detector");
      detectionResult.value = detector[0]['label'];
      print(detectionResult.value);
      //await _speak(detectionResult.value);
    }
  }
}