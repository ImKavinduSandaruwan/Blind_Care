import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

import 'package:alan_voice/alan_voice.dart';

void main(){
  runApp(
      TurnByTurnScreen(startLatitude: 6.8, startLongitude: 79.8, endLatitude: 6.9, endLongitude: 79.9)
  );
}

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
  String? _instruction;

  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  late MapBoxOptions _navigationOption;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void setOptions() {
    _navigationOption.bannerInstructionsEnabled = true;
    _navigationOption.language = "en";
    _navigationOption.mode = MapBoxNavigationMode.walking;
    _navigationOption.simulateRoute = false;
    _navigationOption.voiceInstructionsEnabled = true;
    _navigationOption.units = VoiceUnits.imperial;
  }

  void clearOptions() {
    _navigationOption.bannerInstructionsEnabled = false;
    _navigationOption.voiceInstructionsEnabled = false;
  }

  Future<void> initialize() async {
    if (!mounted) return;
    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);
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
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }

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
    await Future.delayed(Duration(seconds: 3));
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:
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
      ),
    );
  }


  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
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