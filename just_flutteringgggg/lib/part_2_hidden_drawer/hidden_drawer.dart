import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part_2_hidden_drawer/zoomed_scaffold.dart';
import 'package:just_flutteringgggg/part_2_hidden_drawer/menu_screen.dart';
import 'package:just_flutteringgggg/part_2_hidden_drawer/resturant_screen.dart';
import 'package:just_flutteringgggg/part_2_hidden_drawer/other_screen.dart';
import 'package:just_flutteringgggg/part_2_hidden_drawer/screen.dart';

class HiddenDrawer extends StatefulWidget {
  _HiddenDrawerState createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  Screen activeScreen = restaurantScreen;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ZoomedScaffold(
          menuList: MenuScreen(),
          activeScreen: activeScreen,
        )
      ],
    );
  }
}
