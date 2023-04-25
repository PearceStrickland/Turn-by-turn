import 'dart:typed_data';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_turn_by_turn/helpers/shared_prefs.dart';
import 'package:mapbox_turn_by_turn/screens/homescreen.dart';
import 'package:mapbox_turn_by_turn/ui/rate_ride.dart';
import 'package:mapbox_turn_by_turn/screens/bluetooth.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mapbox_turn_by_turn/widget.dart';
import 'dart:convert';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'package:mapbox_turn_by_turn/screens/GlobalVariables.dart';

ScreenshotController screenshotController = ScreenshotController();

var test;

class TurnByTurn extends StatefulWidget {
  const TurnByTurn({Key? key}) : super(key: key);

  @override
  State<TurnByTurn> createState() => _TurnByTurnState();
}

class _TurnByTurnState extends State<TurnByTurn> {
  var index = 1;
  var initial = 0;
  // Waypoints to mark trip start and end
  LatLng source = getTripLatLngFromSharedPrefs('source');
  LatLng destination = getTripLatLngFromSharedPrefs('destination');
  late WayPoint sourceWaypoint, destinationWaypoint;
  var wayPoints = <WayPoint>[];

  // Config variables for Mapbox Navigation
  late MapBoxNavigation directions;
  late MapBoxOptions _options;
  late double distanceRemaining, durationRemaining;

  late MapBoxNavigationViewController _controller;
  final bool isMultipleStop = false;
  String instruction = "";
  String step = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    index = 1;
    if (!mounted) return;

    // Setup directions and options
    directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    _options = MapBoxOptions(
        zoom: 18.0,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        isOptimized: true,
        units: VoiceUnits.metric,
        simulateRoute: true,
        language: "en");

    // Configure waypoints
    sourceWaypoint = WayPoint(
        name: "Source", latitude: source.latitude, longitude: source.longitude);
    destinationWaypoint = WayPoint(
        name: "Destination",
        latitude: destination.latitude,
        longitude: destination.longitude);
    wayPoints.add(sourceWaypoint);
    wayPoints.add(destinationWaypoint);

    // Start the trip
    await directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

  @override
  Widget build(BuildContext context) {
    index = 1;
    initial = 0;
    return const RateRide();
  }

  Future<void> checker(String? nav_data) async {
    //if (nav_data != null) {
    // Capture the image of the entire screen

    //await theUUID.write(utf8.encode("on"));
    //await theUUID.write(utf8.encode("off"));
    //await theUUID2.write(utf8.encode(test));
    // }
    //await theUUID.write(utf8.encode("on"));
    //await theUUID.write(utf8.encode("off"));
    await TurnUUID.write(utf8.encode(nav_data!));
  }

  Future<void> _onRouteEvent(e) async {
    distanceRemaining = await directions.distanceRemaining;
    durationRemaining = await directions.durationRemaining;

    //checker();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        arrived = progressEvent.arrived!;
        test = progressEvent.currentLeg!.steps![index].instructions;
        //Navigator.push(
        //context, MaterialPageRoute(builder: (_) => HomeScreen()));

        //checker(progressEvent.currentLeg!.steps![index].instructions);

        if (progressEvent.currentStepInstruction != instruction) {
          if (gv.start == "start") {
            print(progressEvent.currentLeg!.steps![index].instructions);
            checker(progressEvent.currentLeg!.steps![index].instructions);
            gv.start = "end";
            index++;
          } else {
            print(progressEvent.currentLeg!.steps![index + 1].instructions);
            checker(progressEvent.currentLeg!.steps![index + 1].instructions);
            index++;
          }
        }

        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;

      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        arrived = true;
        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
        index = 1;
        break;
      case MapBoxEvent.navigation_cancelled:
        print("hey");
        index = 1;
        routeBuilt = false;
        isNavigating = false;
        break;
      default:
        break;
    }
    setState(() {});
  }
}
