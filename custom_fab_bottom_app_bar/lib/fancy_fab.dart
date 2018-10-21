import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  FancyFab({this.onPressed, this.tooltip, this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;

  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;

  double _fabHeight = 56.0;

  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animateColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.00,
          1.00,
          curve: _curve,
        ),
      ),
    );

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: 14.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.75, curve: _curve),
      ),
    );
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget add() => Container(
          child: FloatingActionButton(
        onPressed: null,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ));

  Widget inbox() => Container(
        child: FloatingActionButton(
          onPressed: null,
          tooltip: 'Inbox',
          child: Icon(Icons.inbox),
        ),
      );

  Widget image() => Container(
          child: FloatingActionButton(
        onPressed: null,
        tooltip: 'Image',
        child: Icon(Icons.image),
      ));

  Widget toggle() => FloatingActionButton(
        backgroundColor: _animateColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: _animateIcon,
        ),
      );

  Widget build(context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(
                0.0, _translateButton.value * 3.0, 0.0),
            child: add(),
          ),
          Transform(
            transform: Matrix4.translationValues(
                0.0, _translateButton.value * 2.0, 0.0),
            child: image(),
          ),
          Transform(
            transform:
                Matrix4.translationValues(0.0, _translateButton.value, 0.0),
            child: inbox(),
          ),
          toggle(),
        ],
      );
}
