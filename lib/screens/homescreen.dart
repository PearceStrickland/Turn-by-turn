import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:mapbox_turn_by_turn/screens/bluetooth.dart';
import 'package:mapbox_turn_by_turn/screens/navhome.dart';
import 'package:mapbox_turn_by_turn/screens/bluetooth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

ScreenshotController screenshotController = ScreenshotController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _captureAndSaveScreenshot();
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
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Decreased spacing between buttons
                  SizedBox(
                    width: 200,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Spotify'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
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
