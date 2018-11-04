import 'dart:math';
import 'package:flutter/material.dart';

class PolarCoord {
  final double angle;
  final double radius;

  factory PolarCoord.fromPoints(Point origin, Point point) {
    //Getting vector from point to the origin
    final Point vectorPoint = point - origin;
    final vector = Offset(vectorPoint.x, vectorPoint.y);

    //The PolarCoord is
    //  the angle the vector forms with x-axis and
    //  the distance to the vector
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
typedef RadialDragUpdate = Function(PolarCoord updatedCoord);
typedef RadialDragEnd = Function();

class RadialDragGestureDetector extends StatefulWidget {
  final RadialDragStart onRadialDragStart;
  final RadialDragUpdate onRadialDragUpdate;
  final RadialDragEnd onRadialDragEnd;
  final Widget child;

  RadialDragGestureDetector(
      {@required this.onRadialDragStart,
      @required this.onRadialDragUpdate,
      @required this.onRadialDragEnd,
      @required this.child});
  _RadialDragGestureDetectorState createState() =>
      _RadialDragGestureDetectorState();
}

class _RadialDragGestureDetectorState extends State<RadialDragGestureDetector> {
  PolarCoord _polarCoordFromGlobalOffset(Offset globalOffset) {
    // Convert user's global touch offset to widget's local offset
    final localTouchOffset =
        (context.findRenderObject() as RenderBox).globalToLocal(globalOffset);

    // Convert local offsets to Point
    final Point localTouchPoint =
        Point(localTouchOffset.dx, localTouchOffset.dy);

    // Create a Point at the center of this widget to act as the origin
    final Point centerPoint =
        Point(context.size.width / 2, context.size.height / 2);

    return PolarCoord.fromPoints(centerPoint, localTouchPoint);
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
