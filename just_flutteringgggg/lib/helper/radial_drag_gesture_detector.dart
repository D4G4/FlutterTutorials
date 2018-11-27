import 'package:flutter/material.dart';

import 'dart:math';

///[src: Wikipedia] In Mathematics, the polar coordinate system is
/// a 2D coordinate system in which each `point` and a `plane` is determined
/// by a `distance` from reference point and an `angle` from a reference direction.
///
class PolarCoord {
  final double angle;
  final double radius;

  factory PolarCoord.fromPoints(Point origin, Point endPoint) {
    // Subtract the origin of the point
    // to get the vector from Origin -> Point
    final Point vectorPoint = endPoint - origin;
    final vector = Offset(vectorPoint.x, vectorPoint.y);

    // The polar coordinate is the angle the vector forms with the x-axis and
    // the distance of the vector
    return PolarCoord._internal(vector.direction, vector.distance);
  }

  PolarCoord._internal(this.angle, this.radius);

  @override
  String toString() {
    return 'PolarCoord: ${radius.toStringAsFixed(2)} ' +
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

  RadialDragGestureDetector({
    this.onRadialDragStart,
    this.onRadialDragUpdate,
    this.onRadialDragEnd,
    @required this.child,
  });
  _RadialDragGestureDetectorState createState() =>
      _RadialDragGestureDetectorState();
}

/// Reports back PolarCoordinates (Angle and Radiants)
class _RadialDragGestureDetectorState extends State<RadialDragGestureDetector> {
  _onPanStart(DragStartDetails details) {
    if (null != widget.onRadialDragStart) {
      final PolarCoord polarCoord =
          _polarCoordFromGlobalOffset(details.globalPosition);
      widget.onRadialDragStart(polarCoord);
    }
  }

  _onPanUpdate(DragUpdateDetails details) {
    if (null != widget.onRadialDragUpdate) {
      final PolarCoord polarCoord =
          _polarCoordFromGlobalOffset(details.globalPosition);
      widget.onRadialDragUpdate(polarCoord);
    }
  }

  _onPanEnd(DragEndDetails details) {
    if (null != widget.onRadialDragEnd) {
      widget.onRadialDragEnd();
    }
  }

  PolarCoord _polarCoordFromGlobalOffset(Offset globalOffset) {
    // Convert user's global touch offset to an offset that is local to this widget
    final Offset localTouchOffset =
        (context.findRenderObject() as RenderBox).globalToLocal(globalOffset);

    /// Convert the local offset to a `Point`
    final Point localTouchPoint =
        Point(localTouchOffset.dx, localTouchOffset.dy);

    /// Create a point at the center of the widget to act as the origin
    Point originPoint = Point(context.size.width / 2, context.size.height / 2);

    return PolarCoord.fromPoints(originPoint, localTouchPoint);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: widget.child,
      );
}
