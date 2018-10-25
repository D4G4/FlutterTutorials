///`Nice learning`
/// RenderTree is a long living tree :: actually gets mutated/updated overtime
/// the way our list(menu) gets on to the screen is that the
/// `WidgetTree` gets essentially transferred over to the `RenderTree`
/// and there's a Render object that actually paints this to the screen.
///
/// Because `RenderObject` is doing the paining and because it's long living,
/// we can get a hold of that RenderObject and we can ask it for it's size
/// and we can ask for it's global position on the screen.
///
/// That's how we managed to get the "Red Rectangualr selector on the screen"
/// How to get that RenderBox? -> menu_screen.dart -> _AnimatedMenuListItem -> updateSelectedRenderBox()
///
/// Also, `Context in flutter` is [BuildContext] and
/// it represents where in the `RenderTree` that item is.
///
/// So a `Context` is different for every single widget in the tree.
/// Because Context says "this is where you are in the tree".
///
/// `renderBox.localToGlobal(point)` ->
/// "Here's the LocalPoint in your coordinate space, tell me where that point is on the screen."
///
///
///
///
/// `Keys`
/// We can ask [GlobalKey] to ask for the StateObject associated with that Key
/// Reason: no otehr widget in entire app is allowed to have the same key
/// So if only one widget has the key, then Flutter allows to associate the state with it

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
  var selectedMenuItemId = 'restaurant';

  final menu = Menu(items: [
    MenuItem(id: 'restaurant', title: 'THE PADDOCK'),
    MenuItem(id: 'other 1', title: 'THE HERO'),
    MenuItem(id: 'other 2', title: 'HELP US GROW'),
    MenuItem(id: 'other 3', title: 'SETTINGS'),
  ]);

  @override
  Widget build(BuildContext context) {
    return ZoomedScaffold(
      activeScreen: activeScreen,
      menuScreen: MenuScreen(
        menu: menu,
        selectedMenuItemId: selectedMenuItemId,
        onMenuItemSelected: (String itemId) {
          selectedMenuItemId = itemId;
          if (itemId == 'restaurant') {
            activeScreen = restaurantScreen;
          } else {
            activeScreen = otherScreen;
          }
          setState(() {});
        },
      ),
    );
  }
}

/// 1:08:00   (ZoomedMenuController is kinda important)
