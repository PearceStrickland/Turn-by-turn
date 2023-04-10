import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_turn_by_turn/helpers/shared_prefs.dart';
import 'package:mapbox_turn_by_turn/screens/prepare_ride.dart';

class NavHome extends StatefulWidget {
  const NavHome({Key? key}) : super(key: key);

  @override
  State<NavHome> createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> {
  LatLng currentLocation = getCurrentLatLngFromSharedPrefs();
  late String currentAddress;
  late CameraPosition _initialCameraPosition;

  //_currAdress(LatLng value) async {
  //return await getParsedReverseGeocoding(currentLocation);
  //}

  @override
  void initState() {
    super.initState();
    // Set initial camera position and current address
    _initialCameraPosition = CameraPosition(target: currentLocation, zoom: 14);
    //var currentAddress = await _currAdress(currentLocation);
    //print(currentAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
