import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part_2_hidden_drawer/screen.dart';
import 'package:just_flutteringgggg/part_2_hidden_drawer/menu_screen.dart';

class ZoomedScaffold extends StatefulWidget {
  final Widget menuList;
  final Screen activeScreen;

  ZoomedScaffold({this.activeScreen, this.menuList});
  _ZoomedScaffoldState createState() => _ZoomedScaffoldState();
}

class _ZoomedScaffoldState extends State<ZoomedScaffold> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.menuList,
        _createContentFromScreens(),
      ],
    );
  }

  _createContentFromScreens() {
    return zoomAndSlideContent(Container(
      decoration: BoxDecoration(image: widget.activeScreen.decorationImage),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
          title: Text(widget.activeScreen.title),
        ),
        body: widget.activeScreen.contentBuilder(context),
      ),
    ));
  }

  zoomAndSlideContent(Widget content) {
    
  }
}
