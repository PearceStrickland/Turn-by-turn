import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:mapbox_turn_by_turn/screens/bluetooth.dart';
import 'package:mapbox_turn_by_turn/screens/homescreen1.dart';
import 'package:mapbox_turn_by_turn/screens/navhome.dart';
import 'package:mapbox_turn_by_turn/screens/bluetooth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

ScreenshotController screenshotController = ScreenshotController();

class HomeScreen extends StatefulWidget {
  final VoidCallback? onCheckerCalled;

  HomeScreen({Key? key, this.onCheckerCalled}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var navback = Color.fromARGB(255, 0, 4, 254);
  var spotback = Color.fromARGB(255, 255, 0, 0);
  var blueback = Color.fromARGB(255, 0, 4, 254);
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _captureAndSaveScreenshot();
      checker();
    });
  }

  Future<void> _captureAndSaveScreenshot() async {
    Uint8List? capturedImage = await screenshotController.capture();
    String base64Image = base64Encode(capturedImage as List<int>);
    print(base64Image);
    String fileName = 'yip.txt'; // Set desired file name
    io.Directory appDocDir =
        await getApplicationDocumentsDirectory(); // Use dart:io.Directory
    String appDocPath = appDocDir.path;
    String imagePath = '$appDocPath/$fileName';
    io.File imageFile = io.File(imagePath);
    await imageFile.writeAsString(base64Image);

    print('Image saved at $imagePath');
  }

  Future<void> checker() async {
    if (widget.onCheckerCalled != null) {
      widget.onCheckerCalled!();
    }
    if (theUUID3 == null) {
      print('null check');
    } else {
      await theUUID3.setNotifyValue(true);
      theUUID3.value.listen((value) {
        print(value.toString());
        if (value.toString() == "[108, 101, 102, 116]" &&
            navback == Color.fromARGB(255, 255, 0, 0)) {
          setState(() {
            navback = Color.fromARGB(255, 0, 4, 254);
            spotback = Color.fromARGB(255, 255, 0, 0);
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const NavHome()));
        } else if (value.toString() == "[108, 101, 102, 116]" &&
            blueback == Color.fromARGB(255, 255, 0, 0)) {
          setState(() {
            blueback = Color.fromARGB(255, 0, 4, 254);
            spotback = Color.fromARGB(255, 255, 0, 0);
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => Bluetooth()));
        } else if (value.toString() == "[114, 105, 103, 104, 116]" &&
            navback == Color.fromARGB(255, 255, 0, 0)) {
          print("check");
          setState(() {
            navback = Color.fromARGB(255, 0, 4, 254);
            spotback = Color.fromARGB(255, 255, 0, 0);
          });
        } else if (value.toString() == "[100, 111, 119, 110]" &&
            spotback == Color.fromARGB(255, 255, 0, 0)) {
          setState(() {
            navback = Color.fromARGB(255, 255, 0, 0);
            spotback = Color.fromARGB(255, 0, 4, 254);
          });
        } else if (value.toString() == "[114, 105, 103, 104, 116]" &&
            spotback == Color.fromARGB(255, 255, 0, 0)) {
          setState(() {
            blueback = Color.fromARGB(255, 255, 0, 0);
            spotback = Color.fromARGB(255, 0, 4, 254);
          });
        } else if (value.toString() == "[100, 111, 119, 110]" &&
            blueback == Color.fromARGB(255, 255, 0, 0)) {
          setState(() {
            spotback = Color.fromARGB(255, 255, 0, 0);
            blueback = Color.fromARGB(255, 0, 4, 254);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: Text('CarAR'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 230,
                  bottom: 0), // Adjusted padding for "Welcome to CarAR!" text
              child: Text(
                'Welcome to CarAR!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const NavHome())),
                      child: Text('Navigation'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: navback,
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Decreased spacing between buttons
                  SizedBox(
                    width: 200,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        checker();
                      },
                      child: Text('Spotify'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: spotback,
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Decreased spacing between buttons
                  SizedBox(
                    width: 200,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Bluetooth())),
                      child: Text('Bluetooth'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: blueback,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
