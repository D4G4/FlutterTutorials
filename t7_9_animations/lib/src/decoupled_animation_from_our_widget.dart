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
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    ///Tween is a StatelessObject
    ///In order to make animation update everytime a frame is changed,
    ///we add a listener to it and then call `setState()`
    animation = Tween(begin: 0.0, end: 500.0).animate(animationController);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      } else if (status == AnimationStatus.completed) {
        animationController.stop(canceled: true);
      }
    });
    animationController.forward();
  }

  @override
  build(context) {
    debugPrint("Build method called MyAppState ${animation.value}");
    return LogoAnimation(animation: animation);
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }
}

///Allows us to seprate widget code from animation code
///It does not maintain the State object
///
///Because we are passing state form other class, we need to create a constructor
///
///As [Animation] is kind of Listenable for [MyAppState],
///we pass this to our LogoAnimation?
///
///We have removed the listener above there, why?
///The `AnimatedWidget` class knows to listen to the change in the frame
///So the state will be changing inside [MyAppState] and the change is listened
///inside [LogoAnimation] class
class LogoAnimation extends AnimatedWidget {
  LogoAnimation({Key key, Animation animation})
      : super(key: key, listenable: animation);

  @override
  build(context) {
    Animation animation = listenable;
    debugPrint("Build method called LogoAnimation ${animation.value}");
    return Center(
      child: Container(
        width: animation.value,
        height: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}
