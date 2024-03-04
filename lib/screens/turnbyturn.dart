import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

void main(){
  runApp(SampleNavigationApp());
}


class SampleNavigationApp extends StatefulWidget {
  @override
  State<SampleNavigationApp> createState() => _SampleNavigationAppState();
}

class _SampleNavigationAppState extends State<SampleNavigationApp> {
  final _origin = WayPoint(name: "start", latitude: 6.8, longitude: 79.8);
  final _destination = WayPoint(name: "end", latitude: 6.9, longitude: 79.9);

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

  Future<void> initialize() async {
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.language = "en";

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _isNavigating
                              ? null
                              : () {
                            if (_routeBuilt) {
                              _controller?.clearRoute();
                            } else {
                              var wayPoints = <WayPoint>[];
                              wayPoints.add(_origin);
                              wayPoints.add(_destination);
                              _controller?.buildRoute(
                                  wayPoints: wayPoints,
                                  options: _navigationOption);
                            }
                          },
                          child: Text(_routeBuilt && !_isNavigating
                              ? "Clear Route"
                              : "Build Route"),
                        ),
                        ElevatedButton(
                          onPressed: _routeBuilt && !_isNavigating
                              ? () {
                            _controller?.startNavigation();
                          }
                              : null,
                          child: const Text("Go"),
                        ),
                        ElevatedButton(
                          onPressed: _isNavigating
                              ? () {
                            _controller?.finishNavigation();
                          }
                              : null,
                          child: const Text("Stop"),
                        ),
                      ],
                    ),
                  ),
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
                ],
              ),
            ],
          ),
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