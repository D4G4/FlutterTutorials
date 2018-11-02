import 'package:flutter/material.dart';

//Learning-> didUpdateWidget()
class SpinnerText extends StatefulWidget {
  final String text;
  SpinnerText({
    this.text = " ",
  });

  @override
  createState() => _SpinnerTextState();
}

class _SpinnerTextState extends State<SpinnerText>
    with TickerProviderStateMixin {
  String topText = " "; //The new text
  String bottomText = " "; //Text we will be reading most of the time

  AnimationController _spinTextAnimationController;
  Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();
    bottomText = widget.text;

    _spinTextAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750))
      ..addListener(() => setState(() {}))
      ..addStatusListener((AnimationStatus status) {
        //means new text came in and both of them just slid all the way down
        if (status == AnimationStatus.completed) {
          setState(() {});
          bottomText = topText;
          topText = " ";
          _spinTextAnimationController.value = 0.0;
        }
      });

    _spinAnimation = CurvedAnimation(
      parent: _spinTextAnimationController,
      curve: Curves.elasticInOut,
    );
  }

  @override
  void dispose() {
    _spinTextAnimationController.dispose();
    super.dispose();
  }

  TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: RectClipper(),
      child: Stack(
        children: <Widget>[
          FractionalTranslation(
            translation: Offset(0.0, _spinAnimation.value - 1.0),
            child: Text(
              topText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          ),
          FractionalTranslation(
            translation: Offset(0.0, _spinAnimation.value),
            child: Text(
              bottomText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          )
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(SpinnerText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      //Need to spin the value
      topText = widget.text;

      //TODO: run animation
      _spinTextAnimationController.forward();
    }
  }
}

class RectClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
