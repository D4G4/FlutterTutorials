import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  String nameOfThePosition;

  Position _position;

  @override
  void initState() {
    super.initState();
  }

  void getCurrentLocation(BuildContext context) async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();

    if (geolocationStatus == GeolocationStatus.granted) {
      var locator = new Geolocator();
      var locationOptions =
          LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

      Stream<Position> positionStream =
          await locator.getPositionStream(locationOptions);

      positionStream.listen((Position position) {
        setState(() {
          lat = position.latitude;
          lng = position.longitude;
          alt = position.altitude;
          accuracy = position.accuracy;
        });
        print("Just got done with setting the state");
        Geolocator().placemarkFromCoordinates(lat, lng).then((placemarkList) {
          nameOfThePosition = placemarkList[0].locality;
          print("location = $nameOfThePosition");
          setState(() {});
        });
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Dfuck is wrong with a stupid permission man?")));

      await Geolocator().getCurrentPosition(LocationAccuracy.best);
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
                "You are at ${lat.toStringAsFixed(5)},${lng.toStringAsFixed(5)} \n $nameOfThePosition"),
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
