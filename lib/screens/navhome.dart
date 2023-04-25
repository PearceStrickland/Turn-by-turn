import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_turn_by_turn/helpers/shared_prefs.dart';
import 'package:mapbox_turn_by_turn/screens/prepare_ride.dart';
import 'package:mapbox_turn_by_turn/screens/bluetooth.dart';
import 'package:mapbox_turn_by_turn/screens/homescreen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

import 'package:screenshot/screenshot.dart';

var button;

class NavHome extends StatefulWidget {
  const NavHome({Key? key}) : super(key: key);
  @override
  State<NavHome> createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> {
  ScreenshotController screenshotController = ScreenshotController();
  LatLng currentLocation = getCurrentLatLngFromSharedPrefs();
  late String currentAddress;
  late CameraPosition _initialCameraPosition;
  HomeScreen _homeScreen = HomeScreen();

  //_currAdress(LatLng value) async {
  //return await getParsedReverseGeocoding(currentLocation);
  //}

  @override
  void initState() {
    super.initState();
    //print(firstval);
    // Set initial camera position and current address
    _initialCameraPosition = CameraPosition(target: currentLocation, zoom: 14);
    //var currentAddress = await _currAdress(currentLocation);
    //print(currentAddress);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Code to run after everything is loaded goes here
      // For example, you can call a function or fetch data here
      //_captureAndSaveScreenshot();
      //checker();
      // Example:
    });
  }

  Future<void> checker() async {
    if (theUUID3 == null) {
      print('null check');
    } else {
      await theUUID3.setNotifyValue(true);
      theUUID3.value.listen((value) {
        print(value.toString());
        if (value.toString() == "[108, 101, 102, 116]") {
          print("worked");
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const PrepareRide()));
        }
      });
    }
  }

  Future<void> _captureAndSaveScreenshot() async {
    Uint8List? capturedImage = await screenshotController.capture();
    String base64Image = base64Encode(capturedImage as List<int>);
    print(base64Image);
    String fileName = 'yay.txt'; // Set desired file name
    io.Directory appDocDir =
        await getApplicationDocumentsDirectory(); // Use dart:io.Directory
    String appDocPath = appDocDir.path;
    String imagePath = '$appDocPath/$fileName';
    io.File imageFile = io.File(imagePath);
    await imageFile.writeAsString(base64Image);

    print('Image saved at $imagePath');
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
        controller: screenshotController,
        child: Scaffold(
          body: Stack(
            children: [
              MapboxMap(
                accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
                initialCameraPosition: _initialCameraPosition,
                myLocationEnabled: true,
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Hi there!',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          const Text('You are currently here:'),
                          const Text('Atlanta, Georgia',
                              style: TextStyle(color: Colors.indigo)),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const PrepareRide())),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Where do you wanna go today?'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
