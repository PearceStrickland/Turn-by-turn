import 'dart:convert';

import 'package:mapbox_turn_by_turn/screens/bluetooth.dart';

Future<void> ScreenSend(String? screendata) async {
  await ScreenUUID.write(utf8.encode(screendata!));
}

Future<void> SongSend(String? songdata) async {
  await SongUUID.write(utf8.encode(songdata!));
}

class gv {
  static String strCurPage = 'homescreen_nav';
  static String start = "start";
  static int song_index = 0;
}
