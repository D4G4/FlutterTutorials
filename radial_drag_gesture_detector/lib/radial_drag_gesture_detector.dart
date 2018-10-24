import 'package:flutter/material.dart';

import 'dart:math';

///[src: Wikipedia] In mathematics, the polar coordinate system is
///a 2D coordinate system in which each `point` and a `plane` is determined
///by a `distance` from a reference point and an `angle` from a reference direciton.
///
class PolarCoord {
  final double angle;
  final double radius;

  factory PolarCoord.fromPoints(Point origin, Point point) {
    //Subtract the origin of the point to get vector from the origin
    //to the point
    final Point vectorPoint = point - origin;
    final vector = Offset(vectorPoint.x, vectorPoint.y);

    // The polar coordinate is the angle the vector forms with the x-axis and
    // the distance of the vector.
    return PolarCoord._internal(vector.direction, vector.distance);
  }

  PolarCoord._internal(this.angle, this.radius);

  @override
  String toString() {
    return 'Polar Coord: ${radius.toStringAsFixed(2)} ' +
        ' at ${(angle / (2 * pi) * 360).toStringAsFixed(2)}°';
  }
}

typedef RadialDragStart = Function(PolarCoord startCoord);
typedef RaidalDragUpdate = Function(PolarCoord updateCoord);
typedef RadialDragEnd = Function();

class RadialDragGestureDetector extends StatefulWidget {
  final RadialDragStart onRadialDragStart;
  final RaidalDragUpdate onRadialDragUpdate;
  final RadialDragEnd onRadialDragEnd;
  final Widget child;

  RadialDragGestureDetector({
    this.onRadialDragStart,
    this.onRadialDragUpdate,
    this.onRadialDragEnd,
    @required this.child,
  });

  @override
  _RadialDragGestureDetectorState createState() =>
      _RadialDragGestureDetectorState();
}

class _RadialDragGestureDetectorState extends State<RadialDragGestureDetector> {
  _polarCoordFromGlobalOffset(Offset globalOffset) {
    // Convert the uset's global touch offset to an offset that is local to this widget
    final localTouchOffset =
        (context.findRenderObject() as RenderBox).globalToLocal(globalOffset);

    // Convert the local offset to a Point so that we can do math with id
    final localTouchPoint = Point(localTouchOffset.dx, localTouchOffset.dy);

    // Create a Point at the center of this widget to act as the origin
    final originPoint = Point(context.size.width / 2, context.size.height / 2);

    //Now we'll get an angle and radius/line
    return PolarCoord.fromPoints(originPoint, localTouchPoint);
  }

  _onPanStart(DragStartDetails details) {
    if (null != widget.onRadialDragStart) {
      final polarCoord = _polarCoordFromGlobalOffset(details.globalPosition);
      widget.onRadialDragStart(polarCoord);
    }
  }

  _onPanUpdate(DragUpdateDetails details) {
    if (null != widget.onRadialDragUpdate) {
      final polarCoord = _polarCoordFromGlobalOffset(details.globalPosition);
      widget.onRadialDragUpdate(polarCoord);
    }
  }

  _onPanEnd(DragEndDetails details) {
    if (null != widget.onRadialDragEnd) {
      widget.onRadialDragEnd();
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: widget.child,
      );
}
