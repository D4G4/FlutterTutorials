import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  createState() => MyAppState();
}

/// AnimationController derives from AnimationObject
///
/// `SingleTickerProviderStateMixin` -> Provides Ticker object
/// and ticker object listen to the refresh rate of the screen and
/// give us back various numbers which will be passed to the AnimationController
/// `vsync: this`
class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  initState() {
    super.initState();
    debugPrint("Init state");
    animationController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    ///Tween is a StatelessObject
    ///In order to make animation update everytime a frame is changed,
    ///we add a listener to it and then call `setState()`
    animation = Tween(begin: 0.0, end: 500.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    animationController.repeat();
  }

  @override
  build(context) {
    debugPrint("Build method called ${animation.value}");
    return Center(
      child: Container(
        width: animation.value,
        height: animation.value,
        child: FlutterLogo(),
      ),
    );
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }
}
