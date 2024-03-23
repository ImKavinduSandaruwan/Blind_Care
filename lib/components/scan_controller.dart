import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_tts/flutter_tts.dart';

class ScanController extends GetxController{

  final FlutterTts _flutterTts = FlutterTts();

  bool ttsRunning = false;

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTlLite();
  }

  void initTts() async {
    // Configure TTS engine
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.awaitSpeakCompletion(true);
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

  initTlLite() async {
    await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/mobilenet_v1_1.0_224.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false
    );
  }

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
      await _speak(detectionResult.value);

    }
  }

  _speak(String textSpeech) async {
    if (ttsRunning){
      return null;
    }
    ttsRunning = true;
    await _flutterTts.speak(textSpeech);
    await _flutterTts.awaitSpeakCompletion(true);
    ttsRunning = false;
  }
}