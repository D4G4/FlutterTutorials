import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'dart:async';

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double lat = 0.0;
  double lng = 0.0;
  double alt = 0.0;
  double accuracy = 0.0;
  double headingTowards = 0.0;

  @override
  void initState() {
    super.initState();
    requestAndCheckPermission();
    checkLocationStatus();
  }

  void requestAndCheckPermission() async {
    bool status =
        await SimplePermissions.checkPermission(Permission.AccessFineLocation);
    if (!status) {
      bool userGrantedPermissions = await SimplePermissions.requestPermission(
          Permission.AccessFineLocation);
      if (!userGrantedPermissions) SimplePermissions.openSettings();
    }
  }

  void checkLocationStatus() async {
    final GeolocationStatus status =
        await Geolocator().checkGeolocationPermissionStatus();
    print(status.toString());
    if (status == GeolocationStatus.granted) return;
  }

  void getCurrentLocation(BuildContext context) async {
    try {
      Position position =
          await Geolocator().getCurrentPosition(LocationAccuracy.best);
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        alt = position.altitude;
        accuracy = position.accuracy;
        headingTowards = position.heading;
      });
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Dfuck is wrong with a stupid permission man?")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Geolocation Example")),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
                "You are at ${lat.toStringAsFixed(5)},${lng.toStringAsFixed(5)}"),
          ),
          Text("With an accuracy of ${accuracy.toStringAsFixed(1)}"),
          Text("Heading towards $headingTowards"),
          RaisedButton(
            child: Text("Get current location"),
            onPressed: () => getCurrentLocation(context),
          )
        ],
      )),
    );
  }
}
