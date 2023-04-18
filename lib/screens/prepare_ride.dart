import 'package:flutter/material.dart';
import 'package:mapbox_turn_by_turn/widgets/endpoints_card.dart';
import 'package:mapbox_turn_by_turn/widgets/search_listview.dart';
import 'package:mapbox_turn_by_turn/screens/bluetooth.dart';
import '../widgets/review_ride_fa_button.dart';
import 'package:mapbox_turn_by_turn/screens/homescreen.dart';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../helpers/mapbox_handler.dart';
import '../helpers/shared_prefs.dart';
import '../screens/review_ride.dart';

class PrepareRide extends StatefulWidget {
  const PrepareRide({Key? key}) : super(key: key);

  @override
  State<PrepareRide> createState() => _PrepareRideState();

  // Declare a static function to reference setters from children
  static _PrepareRideState? of(BuildContext context) =>
      context.findAncestorStateOfType<_PrepareRideState>();
}

class _PrepareRideState extends State<PrepareRide> {
  bool isLoading = false;
  bool isEmptyResponse = true;
  bool hasResponded = false;
  bool isResponseForDestination = false;

  String noRequest = 'Please enter an address, a place or a location to search';
  String noResponse = 'No results found for the search';

  List responses = [];
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // Perform initialization tasks here, after everything is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Code to run after everything is loaded goes here
      // For example, you can call a function or fetch data here

      // Example:
      checker();
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
        }
      });
    }
  }

  // Define setters to be used by children widgets
  set responsesState(List responses) {
    setState(() {
      this.responses = responses;
      hasResponded = true;
      isEmptyResponse = responses.isEmpty;
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(() {
        isLoading = false;
      }),
    );
  }

  set isLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  set isResponseForDestinationState(bool isResponseForDestination) {
    setState(() {
      this.isResponseForDestination = isResponseForDestination;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Car AR'),
        //actions: const [
        //CircleAvatar(backgroundImage: AssetImage('assets/image/person.jpg')),
        //],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              endpointsCard(sourceController, destinationController),
              isLoading
                  ? const LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  : Container(),
              isEmptyResponse
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                          child: Text(hasResponded ? noResponse : noRequest)))
                  : Container(),
              searchListView(responses, isResponseForDestination,
                  destinationController, sourceController),
            ],
          ),
        ),
      ),
      floatingActionButton: reviewRideFaButton(context),
    );
  }
}
