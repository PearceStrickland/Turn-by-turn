import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mapbox_turn_by_turn/widget.dart';
import 'package:mapbox_turn_by_turn/screens/navhome.dart';
import 'package:mapbox_turn_by_turn/screens/homescreen.dart';

var theUUID;
var theUUID2;
var count = 0;
var button_state;
var theUUID3;
var TurnUUID;
var ScreenUUID;
var SongUUID;

class Bluetooth extends StatefulWidget {
  Bluetooth({Key? key}) : super(key: key);

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
        actions: <Widget>[
          // Go Back button
          TextButton(
            child: Text('Go Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (context, snapshot) {
                  // Check if the stream has data
                  if (snapshot.hasData) {
                    // Get the list of ScanResults from the snapshot
                    List<ScanResult> scanResults = snapshot.data!;

                    // Sort the list alphabetically by title
                    scanResults.sort((a, b) => a.device.name
                        .toLowerCase()
                        .compareTo((b.device.name.toLowerCase())));

                    // Create a list of ListTiles sorted by title
                    List<Widget> sortedListTiles = scanResults
                        .map((result) => ListTile(
                              title: Text(result.device.name == ""
                                  ? "No Name "
                                  : result.device.name),
                              subtitle: Text(result.device.id.toString()),
                              onTap: () => Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                result.device.connect();
                                return DeviceScreen(device: result.device);
                              })),
                            ))
                        .toList();

                    // Return the sortedListTiles wrapped in a Column widget
                    return Column(
                      children: sortedListTiles,
                    );
                  } else {
                    // Return a placeholder widget when there is no data in the stream
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () {
                      print(c);
                      print("nice1");
                      if (c.uuid.toString() ==
                          "5a359055-90d5-4e7a-80e3-78740ed594d0") {
                        theUUID3 = c;
                        print("nice");
                      }
                      if (c.uuid.toString() ==
                          "25ab6b2f-375e-4633-88cc-6a4eb5ebfe20") {
                        TurnUUID = c;
                        print("turn");
                      }
                      if (c.uuid.toString() ==
                          "37b753ef-9c74-48b0-a835-6c48c5ebf6bd") {
                        ScreenUUID = c;
                        print("screen");
                      }
                      if (c.uuid.toString() ==
                          "d69c1f38-a397-41a1-b90b-bdfad9f106a0") {
                        SongUUID = c;
                        print("song");
                      }

                      c.read();
                    },
                    onWritePressed: () async {
                      if (c.uuid.toString() ==
                          "3b802c61-3308-476b-bef4-6a1ca763d842") {
                        theUUID = c;
                      }
                      if (c.uuid.toString() ==
                          "00802c61-3308-476b-bef4-6a1ca763d842") {
                        theUUID2 = c;
                      }

                      await c.write(utf8.encode("on"));
                      await c.read();
                    },
                    onNotificationPressed: () async {
                      //await c.write(utf8.encode("off"));
                      await c.setNotifyValue(true);
                      c.value.listen((value) {
                        print(value);
                      });
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return TextButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data! ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
