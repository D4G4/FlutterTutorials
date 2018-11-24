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
  String selectedItemId = 'restaurant';

  final menu = MenuList(items: [
    MenuItem(id: 'restaurant', title: 'THE PADDOCK'),
    MenuItem(id: 'other1', title: 'THE HERO'),
    MenuItem(id: 'other2', title: 'HELP US GROW'),
    MenuItem(id: 'other3', title: 'SETTINGS'),
  ]);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ZoomedScaffold(
          menuScreen: MenuScreen(
            menuList: menu,
            selectedMenuItemId: selectedItemId,
            onMenuItemSelected: (String itemId) {
              selectedItemId = itemId;
              if (itemId == 'restaurant') {
                activeScreen = restaurantScreen;
              } else {
                activeScreen = otherScreen;
              }
              setState(() {});
            },
          ),
          activeScreen: activeScreen,
        )
      ],
    );
  }
}
