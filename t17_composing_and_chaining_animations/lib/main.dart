//Staggered Animation : Using multiple controllers

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/scheduler.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// `orCancel` adds error handling to our controller forward method.
  /// So, if the controller moves forward and something happens then it throws
  /// [TickerCanceled] exception
  ///
  Future _startAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      print('Animation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 5.0;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animations'),
        ),
        body: GestureDetector(
          onTap: _startAnimation,
          child: Center(
            child: Container(
              width: 350.0,
              height: 350.0,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                border: Border.all(
                  color: Colors.blueGrey.withOpacity(0.8),
                ),
              ),
              child: AnimatedBox(controller: _controller),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBox extends StatelessWidget {
  AnimatedBox({Key key, this.controller})
      : opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(0.0, 0.2, curve: Curves.fastOutSlowIn)),
        ),
        // Rotating twice
        rotate = Tween<double>(
          begin: 0.0,
          end: (3.141 * 4),
        ).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(0.1, 0.3, curve: Curves.ease)),
        ),
        // Move up and to the right
        movement = EdgeInsetsTween(
          begin: EdgeInsets.only(bottom: 10.0, left: 0.0),
          end: EdgeInsets.only(bottom: 00.0, left: 15.0),
        ).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(0.2, 0.4, curve: Curves.fastOutSlowIn)),
        ),
        // Box scale upwards
        //  The begin properties actually apply
        //  retroactively(taking effect from a date in the past) to the animation.
        //  This means that when the box actually appears, it will begin with
        //  50 x 50 dimension
        width = Tween<double>(
          begin: 50.0,
          end: 300.0,
        ).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(0.4, 0.6, curve: Curves.ease)),
        ),
        height = Tween<double>(
          begin: 50.0,
          end: 300.0,
        ).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(0.4, 0.6, curve: Curves.bounceInOut)),
        ),
        // Converting box -> circle
        radius = BorderRadiusTween(
          begin: BorderRadius.circular(0.0),
          end: BorderRadius.circular(200.0),
        ).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(
                0.6,
                0.9,
                curve: Curves.ease,
              )),
        ),
        // Color change from beginning to end
        color = ColorTween(
          begin: Colors.red[200],
          end: Colors.deepPurple[900],
        ).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(0.0, 0.75, curve: Curves.linear)),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> movement;
  final Animation<BorderRadius> radius;
  final Animation<Color> color;
  final Animation<double> rotate;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          padding: movement.value,
          transform: Matrix4.identity()..rotateZ(rotate.value),
          alignment: Alignment.center,
          child: Opacity(
            opacity: opacity.value,
            child: Container(
              width: width.value,
              height: height.value,
              decoration: BoxDecoration(
                  color: color.value,
                  border: Border.all(color: Colors.cyan, width: 2.0),
                  borderRadius: radius.value),
            ),
          ),
        );
      },
    );
  }
}
