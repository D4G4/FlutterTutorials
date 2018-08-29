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
  Animation tweenBasedAnimation;
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
    tweenBasedAnimation = Tween(begin: 0.0, end: 500.0).animate(animationController);

    tweenBasedAnimation.addStatusListener((status) {
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
    debugPrint("Build method called MyAppState ${tweenBasedAnimation.value}");
    return LogoAnimation(animation: tweenBasedAnimation);
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }
}

///Allows us to seprate widget code from animation code
///
///It does not maintain the State object on its own;
///as we are passing state form other class, we need to create a constructor
///
///Because [Animation] is kind of Listenable for [MyAppState],
///we pass it to our LogoAnimation?
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
    Animation tweenBasedAnimation = listenable;
    debugPrint("Build method called LogoAnimation ${tweenBasedAnimation.value}");
    return Center(
      child: Container(
        width: tweenBasedAnimation.value,
        height: tweenBasedAnimation.value,
        child: FlutterLogo(),
      ),
    );
  }
}
