import 'package:flutter/material.dart';
import 'package:battery/battery.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';

//Why do I need this?
//All of these plugins are centered around platform messages and those are asynchronous
import 'dart:async';
import 'dart:io';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utility Plugins',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> {
  //Battery
  Battery battery = Battery();
  BatteryState batteryState;
  StreamSubscription<BatteryState> batSub;

  //Connectivity
  Connectivity connectivity = Connectivity();
  ConnectivityResult connectionStatus;
  StreamSubscription<ConnectivityResult> connSub;

  //DeviceInfo
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo androidDeviceInfo;
  IosDeviceInfo iosDeviceInfo;

  void initState() {
    super.initState();

    // Purpose??
    //initConnectivity();
    initDeviceInfo();

    connSub =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        print("On connectivity changed");
        connectionStatus = result;
      });
    });
    batSub = battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        batteryState = state;
      });
    });
  }

  Future<Null> initDeviceInfo() async {
    AndroidDeviceInfo aInfo;
    IosDeviceInfo iInfo;
    try {
      if (Platform.isAndroid) {
        //IO library
        aInfo = await deviceInfoPlugin.androidInfo;
      } else if (Platform.isIOS) {
        iInfo = await deviceInfoPlugin.iosInfo;
      }
    } catch (e) {}
    if (!mounted) return;
    setState(() {
      androidDeviceInfo = aInfo;
      iosDeviceInfo = iInfo;
    });
  }

  Future<Null> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
      result = null;
    }

//Case: when the connectivity status is returned before the widget is fully rendered
    ///Checkes if the [State] object that we are working in is mounted inside our widget tree or not
    ///                                  or
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      connectionStatus = result;
    });
  }

  @override
  void dispose() {
    batSub?.cancel();
    connSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Larning Dart utility plugins")),
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: battery.batteryLevel,
              builder: (builderContext, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                      child: Column(
                    children: <Widget>[
                      Text('Battery: $batteryState @ ${snapshot.data}%')
                    ],
                  ));
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Text("Connection Status $connectionStatus"),
            Text("Device id ${androidDeviceInfo.id}}"),
            Text("Device Fingerprint ${androidDeviceInfo.fingerprint}"),
            Text("Device model ${androidDeviceInfo.model}"),
            Text("Device Brand ${androidDeviceInfo.brand}"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.battery_unknown),
        onPressed: () async {
          final int batteryLevel = await battery.batteryLevel;
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                content: Text("Battery level = $batteryLevel%"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Got it"),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
