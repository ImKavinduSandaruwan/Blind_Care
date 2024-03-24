import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:projectblindcare/components/camera_view.dart';
import '../components/scan_controller.dart';

/*void main(){
  runApp(
      TurnByTurnScreen(startLatitude: 6.8805411, startLongitude: 79.8704201, endLatitude: 6.8894260, endLongitude: 79.8763152)
  );
}*/

class TurnByTurnScreen  extends StatefulWidget {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  const TurnByTurnScreen({
    Key? key,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
  }) : super(key: key);

  @override
  State<TurnByTurnScreen> createState() => _TurnByTurnScreen();
}

class _TurnByTurnScreen extends State<TurnByTurnScreen> {
  _TurnByTurnScreen(){
    AlanVoice.addButton(
      "689e5df914105717e09b84ae8ac4018d2e956eca572e1d8b807a3e2338fdd0dc/stage",
      buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT,
    );
    AlanVoice.activate();
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));

    _flutterTts.setLanguage("en-US");
    _flutterTts.setPitch(1.0);
    _flutterTts.setSpeechRate(0.5);
  }
  void _handleCommand(Map<String, dynamic> command) {
    switch(command["command"]) {
      case "build":
        loadNav(_controller!);
        break;
      case "start":
        startNav(_controller!);
        break;
      case "stop":
        stopNav(_controller!);
        break;
      case "exit":
        exitNav(_controller!);
        break;
      default:
        debugPrint("Unknown command");
    }
  }

  late WayPoint _origin, _destination;
  String? _platformVersion;
  String? new_instruction;
  String? old_instruction;
  var countB = 0;
  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  late MapBoxOptions _navigationOption;
  final FlutterTts _flutterTts = FlutterTts();
  ScanController scanController = ScanController();
  var detectedText;
  Future<bool> _checkIsActive() async {
    var isActive = await AlanVoice.isActive();
    if (isActive) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }
  @override
  void dispose() {
    _controller?.dispose();
    scanController.dispose();
    super.dispose();
  }
  _speak(String textSpeech) async {
    if (await _checkIsActive() == false) {
      if(!textSpeech.toLowerCase().contains("others")){
        await _flutterTts.speak(textSpeech);
        await _flutterTts.awaitSpeakCompletion(true);
      }
    }
  }
  void getDirections(double startLat, double startLng, double endLat, double endLng) async {
    String accessToken = 'sk.eyJ1IjoiaW5mYXMyMyIsImEiOiJjbHN1Z2c0ZDgyMGNkMmlwczlreWY0ZTlpIn0.oHcETcNQLDrnB2cO-wQkCA';
    String url = 'https://api.mapbox.com/directions/v5/mapbox/walking/'
        '${startLng.toString()},${startLat.toString()};'
        '${endLng.toString()},${endLat.toString()}?'
        'access_token=sk.eyJ1IjoiaW5mYXMyMyIsImEiOiJjbHN1Z2c0ZDgyMGNkMmlwczlreWY0ZTlpIn0.oHcETcNQLDrnB2cO-wQkCA'
        '&steps=true&voice_instructions=true&&banner_instructions=true&&voice_units=metric';
    var response = await http.get(Uri.parse(url));
    var count = 0;
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      getNextManeuvers(jsonResponse);
    } else {
      debugPrint('Request failed with status: ${response.statusCode}.');
    }
  }
  List<Map<String, dynamic>> maneuvers = [];
  List<Map<String, dynamic>> getNextManeuvers(var jsonResponse) {
    for (var leg in jsonResponse['routes'][0]['legs']) {
      for (var step in leg['steps']) {
        var maneuver = step['maneuver'];
        maneuvers.add({
          'instruction': maneuver['instruction'],
          'bearing_before': maneuver['bearing_before'],
          'bearing_after': maneuver['bearing_after'],
          'location': maneuver['location']
        });
      }
    }
    return maneuvers;
  }
  void setOptions() {
    _navigationOption.bannerInstructionsEnabled = true;
    _navigationOption.language = "en";
    _navigationOption.mode = MapBoxNavigationMode.walking;
    _navigationOption.simulateRoute = false;
    _navigationOption.voiceInstructionsEnabled = false;
    _navigationOption.units = VoiceUnits.metric;
    _navigationOption.alternatives = false;
    _navigationOption.enableRefresh = false;
  }
  void clearOptions() {
    _navigationOption.bannerInstructionsEnabled = false;
    _navigationOption.voiceInstructionsEnabled = false;
  }
  Future<void> initialize() async {
    if (!mounted) return;
    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);
    _navigationOption.voiceInstructionsEnabled = false;
    String? platformVersion;
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    setState(() {
      _platformVersion = platformVersion;
    });
  }
  void beginNav() {
    _origin = WayPoint(name: "start", latitude: widget.startLatitude, longitude: widget.startLongitude);
    _destination = WayPoint(name: "end", latitude: widget.endLatitude, longitude: widget.endLongitude);
    getDirections(widget.startLatitude,widget.startLongitude,widget.endLatitude,widget.endLongitude);
  }
  void loadNav(MapBoxNavigationViewController control){
    _controller?.initialize();
      if (_routeBuilt) {
        control.clearRoute();
      } else {
        beginNav();
        setOptions();
        var wayPoints = <WayPoint>[];
        wayPoints.add(_origin);
        wayPoints.add(_destination);
        _routeBuilt = true;
        control.buildRoute(
            wayPoints: wayPoints,
            options: _navigationOption
        );
      }
  }
  void exitNav(MapBoxNavigationViewController control){
    clearOptions();
    control.finishNavigation();
    _isNavigating = false;
    _controller?.dispose();
    control.dispose();
    _controller?.clearRoute();
    Navigator.pop(context);
  }
  void startNav(MapBoxNavigationViewController control){
    if (_routeBuilt && !_isNavigating)
      {
        control.startNavigation();
        _isNavigating = true;
      }
  }
  stopNav(MapBoxNavigationViewController control) async {
    clearOptions();
    control.finishNavigation();
    _isNavigating = false;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    child: MapBoxNavigationView(
                      options: _navigationOption,
                      onRouteEvent: _onEmbeddedRouteEvent,
                      onCreated: (MapBoxNavigationViewController controller) async {
                        _controller = controller;
                        controller.initialize();
                        },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2,
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                loadNav(_controller!);
                                },
                              child: Text(
                                  "Build Route"
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                exitNav(_controller!);
                                },
                              child: const Text("Exit"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                startNav(_controller!);
                                },
                              child: const Text("Go"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                stopNav(_controller!);
                                },
                              child: const Text("Stop"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 5,
              top: MediaQuery.sizeOf(context).height / 5,
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.sizeOf(context).width/3,
                      height: MediaQuery.sizeOf(context).height/3,
                      child: CameraView()
                  ),
                  Container(
                      width: MediaQuery.sizeOf(context).width/3,
                      height: MediaQuery.sizeOf(context).height/7,
                      child: Obx(() => objSpeech())
                  ),
                ],
              ),
            )
        ],
      ),
      ),
    );
  }
  objSpeech() {
    detectedText = Get.find<ScanController>().detectionResult.value;
    _speak(detectedText);
    return Text(detectedText);
  }
  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          new_instruction= progressEvent.currentStepInstruction;
          if (new_instruction != old_instruction) {
            String printer = maneuvers[countB]["instruction"];
            AlanVoice.playText(printer);
            old_instruction = new_instruction;
            countB++;
          }
        }
        break;
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        await Future.delayed(const Duration(seconds: 3));
        await _controller?.finishNavigation();
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}