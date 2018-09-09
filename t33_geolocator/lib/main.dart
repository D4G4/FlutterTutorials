import 'package:flutter/material.dart';
import 'package:t33_geolocator/src/getPermissionOnClick.dart'
    as getPermissionOnClick;
import 'package:t33_geolocator/src/getPermissionPersistently.dart'
    as getPermissionPersistently;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Location Example',
        theme: ThemeData.dark(),
        home: getPermissionPersistently.Home());
  }
}
