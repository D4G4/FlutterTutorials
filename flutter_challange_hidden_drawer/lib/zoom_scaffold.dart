import 'package:flutter/material.dart';

class ZoomedScaffold extends StatefulWidget {
  final Screen activeScreen;
  final Widget menuScreen;

  ZoomedScaffold({this.activeScreen, this.menuScreen});
  _ZoomedScaffoldState createState() => _ZoomedScaffoldState();
}

class _ZoomedScaffoldState extends State<ZoomedScaffold> {
  Widget createContentDisplay() => zoomAndSlideContent(Container(
        decoration: BoxDecoration(image: widget.activeScreen.background),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(widget.activeScreen.title,
                  style: TextStyle(
                    fontFamily: 'bebas-neue',
                    fontSize: 25.0,
                  )),
              centerTitle: true,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
            ),
            body: widget.activeScreen.contentBuilder(context)),
      ));

  Widget zoomAndSlideContent(Widget content) {
    return Transform(
        transform: Matrix4.translationValues(275.0, 0.0, 0.0)..scale(0.8, 0.8),
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: const Color(0x4400F0F0),
              offset: Offset(0.0, 5.0),
              spreadRadius: 10.0,
              blurRadius: 20.0,
            )
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: content,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        widget.menuScreen,
        createContentDisplay(),
      ],
    );
  }
}

class Screen {
  final String title;
  final DecorationImage background;
  final WidgetBuilder contentBuilder;

  Screen({
    this.title,
    this.background,
    this.contentBuilder,
  });
}

enum MenuState {}

