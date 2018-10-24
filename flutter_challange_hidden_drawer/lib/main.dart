import 'package:flutter/material.dart';
import 'package:flutter_challange_hidden_drawer/resturant_screen.dart';
import 'package:flutter_challange_hidden_drawer/other_screen.dart';
import 'package:flutter_challange_hidden_drawer/menu_screen.dart';

import 'package:flutter_challange_hidden_drawer/zoom_scaffold.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hidden Drawer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> {
  var activeScreen = restaurantScreen;

  @override
  Widget build(BuildContext context) {
    return ZoomedScaffold(
      activeScreen: activeScreen,
      menuScreen: MenuScreen(),
    );
  }
}
