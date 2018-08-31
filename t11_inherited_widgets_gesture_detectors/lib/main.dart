import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(title: "Random Squares", home: MyApp()));

class MyApp extends StatefulWidget {
  createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final Random _random = Random();
  Color color = Colors.amber;

  void onTap() {
    setState(() {
      color = Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextDouble(), //0.0 - 1.0
      );
    });
  }

  build(context) {
    debugPrint("build() MyAppState");
    return ColorState(
      color: color,
      onTap: onTap,
      childWidget: BoxTree(),
    );
  }
}

//InheritedWidget classes are by-default Immutable
class ColorState extends InheritedWidget {
  ColorState({
    Key key,
    this.color,
    this.onTap,
    Widget childWidget,
  }) : super(key: key, child: childWidget);

  final Color color;
  final Function onTap;

  @override
  bool updateShouldNotify(ColorState oldWidget) {
    debugPrint("Update should notify ${color != oldWidget.color}");
    return color != oldWidget.color;
  }

  ///Bcz [InheritedWidget] is a Singleton class
  static ColorState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ColorState);
  }
}

class BoxTree extends StatelessWidget {
  @override
  Widget build(BuildContext covariant) {
    debugPrint("BoxTree build()");
    return Scaffold(
      body: Center(
        child: Row(
          children: <Widget>[
            Box(),
            Box(),
          ],
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("Box build()");
    final colorState = ColorState.of(context);
    return GestureDetector(
      onTap: colorState.onTap,
      child: Container(
        width: 50.0,
        height: 50.0,
        margin: EdgeInsets.only(left: 100.0),
        color: colorState.color,
      ),
    );
  }
}
