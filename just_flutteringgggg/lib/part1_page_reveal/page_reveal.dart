import 'package:flutter/material.dart';
import 'dart:math';

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;

  PageReveal({this.revealPercent, this.child});
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: CircleRevealClipper(revealPercent),
      child: child,
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  CircleRevealClipper(this.revealPercent);

  @override
  bool shouldReclip(CircleRevealClipper oldDelegate) {
    return this.revealPercent != oldDelegate.revealPercent;
  }

  @override
  Rect getClip(Size size) {
    final epicenter = Offset(size.width / 2, size.height * 0.9);

    final theta = atan(epicenter.dy / epicenter.dx);
    final distanceToCorner =
        epicenter.dy / sin(theta); //Max radius we want for the circle

    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;

    // Returns a rect which is actually a square coz we are calculating it via circle
    return Rect.fromLTWH(
        epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }
}
