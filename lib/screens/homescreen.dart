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
import 'package:mapbox_turn_by_turn/screens/GlobalVariables.dart';
import 'package:mapbox_turn_by_turn/screens/turn_by_turn.dart';
import 'package:mapbox_turn_by_turn/screens/GlobalVariables.dart';

ScreenshotController screenshotController = ScreenshotController();

class HomeScreen extends StatefulWidget {
  final VoidCallback? onCheckerCalled;

  HomeScreen({Key? key, this.onCheckerCalled}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var song_list = [
    "Stay - The Kid LAROI & Justin Bieber",
    "Levitating - Dua Lipa feat. DaBaby",
    "Good 4 U - Olivia Rodrigo",
    "Montero (Call Me By Your Name) - Lil Nas X",
    "Industry Baby - Lil Nas X & Jack Harlow",
    "Kiss Me More - Doja Cat feat. SZA",
    "Heat Waves - Glass Animals",
    "Save Your Tears - The Weeknd & Ariana Grande",
    "Peaches - Justin Bieber feat. Daniel Caesar & Giveon",
    "Leave The Door Open - Silk Sonic",
    "Driver's License - Olivia Rodrigo",
    "Deja Vu - Olivia Rodrigo",
    "Blinding Lights - The Weeknd",
    "Famous Friends - Chris Young & Kane Brown",
    "Mood - 24kGoldn feat. Iann Dior",
    "Astronaut In The Ocean - Masked Wolf",
    "Yonaguni - Bad Bunny",
    "Beautiful Mistakes - Maroon 5 feat. Megan Thee Stallion",
    "All I Know So Far - P!nk",
    "Leave Before You Love Me - Marshmello & Jonas Brothers"
  ];
  var right = "[108, 101, 102, 116]";
  var left = "[114, 105, 103, 104, 116]";
  var up = "[100, 111, 119, 110]";
  var down = "[117, 112]";
  var select = "[115, 101, 108, 101, 99, 116]";
  var navback = Color.fromARGB(255, 0, 4, 254);
  var spotback = Color.fromARGB(255, 0, 4, 254);
  var blueback = Color.fromARGB(255, 0, 4, 254);
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      //_captureAndSaveScreenshot();
      checker();
    });
  }

  Future<void> _captureAndSaveScreenshot() async {
    Uint8List? capturedImage = await screenshotController.capture();
    String base64Image = base64Encode(capturedImage as List<int>);
    print(base64Image);
    int startIndex = 0;
    int chunkSize = 150;
    List<String> chunks = [];
    while (startIndex < base64Image.length) {
      int endIndex = startIndex + chunkSize;
      if (endIndex > base64Image.length) {
        endIndex = base64Image.length;
      }
      String chunk = base64Image.substring(startIndex, endIndex);
      print(chunk);
      chunks.add(chunk);
      startIndex = endIndex;
    }
  }

  Future<void> screenSender(screendata) async {
    await theUUID.write(utf8.encode(screendata));
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

        if (value.toString() == select && gv.strCurPage == "review_ride") {
          gv.strCurPage = "nav";
          ScreenSend("nav");
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const TurnByTurn()));
        } else if (value.toString() == select &&
            gv.strCurPage == "homescreen_music") {
          gv.strCurPage = "pause_pause";
          ScreenSend("pause_pause");
          SongSend(song_list[gv.song_index]);
          print(song_list[gv.song_index]);
        } else if (value.toString() == down &&
            gv.strCurPage == "homescreen_nav") {
          gv.strCurPage = "homescreen_music";
          ScreenSend("home_music");
        } else if (value.toString() == up &&
            gv.strCurPage == "homescreen_music") {
          gv.strCurPage = "homescreen_nav";
          ScreenSend("home_nav");
        } else if (value.toString() == right &&
            (gv.strCurPage == "pause_pause" || gv.strCurPage == "play_play")) {
          gv.song_index += 1;
          SongSend(song_list[gv.song_index]);
          print(song_list[gv.song_index]);
        } else if (value.toString() == down && gv.strCurPage == "pause_pause") {
          gv.strCurPage = "pause_home";
          ScreenSend("pause_home");
        } else if (value.toString() == down && gv.strCurPage == "play_play") {
          gv.strCurPage = "play_home";
          ScreenSend("play_home");
        } else if (value.toString() == select &&
            (gv.strCurPage == "pause_home" || gv.strCurPage == "play_home")) {
          gv.strCurPage = "homescreen_nav";
          ScreenSend("home_nav");
        } else if (value.toString() == left &&
            (gv.strCurPage == "pause_pause" || gv.strCurPage == "play_play")) {
          gv.song_index -= 1;
          SongSend(song_list[gv.song_index]);
        } else if (value.toString() == select &&
            gv.strCurPage == "pause_pause") {
          gv.strCurPage = "play_play";
          ScreenSend("play_play");
        } else if (value.toString() == select && gv.strCurPage == "nav") {
          print("check");
          //screenSender("nav");
          gv.strCurPage = "homescreen";
          //Navigator.push(
          //context, MaterialPageRoute(builder: (_) => HomeScreen()));
          Navigator.pop(context);
        } else if (value.toString() == select &&
            navback == Color.fromARGB(255, 255, 0, 0)) {
          setState(() {
            navback = Color.fromARGB(255, 0, 4, 254);
            spotback = Color.fromARGB(255, 255, 0, 0);
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const NavHome()));
        } else if (value.toString() == select &&
            blueback == Color.fromARGB(255, 255, 0, 0)) {
          setState(() {
            blueback = Color.fromARGB(255, 0, 4, 254);
            spotback = Color.fromARGB(255, 255, 0, 0);
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => Bluetooth()));
        } else if (value.toString() == down &&
            navback == Color.fromARGB(255, 255, 0, 0)) {
          print("check");
          setState(() {
            navback = Color.fromARGB(255, 0, 4, 254);
            spotback = Color.fromARGB(255, 255, 0, 0);
          });
        } else if (value.toString() == up &&
            spotback == Color.fromARGB(255, 255, 0, 0)) {
          setState(() {
            navback = Color.fromARGB(255, 255, 0, 0);
            spotback = Color.fromARGB(255, 0, 4, 254);
          });
        } else if (value.toString() == down &&
            spotback == Color.fromARGB(255, 255, 0, 0)) {
          setState(() {
            blueback = Color.fromARGB(255, 255, 0, 0);
            spotback = Color.fromARGB(255, 0, 4, 254);
          });
        } else if (value.toString() == up &&
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
