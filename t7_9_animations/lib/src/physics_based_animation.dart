import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math';

const BOX_COLOR = Colors.cyan;

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      title: "SpringBox",
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  build(context) => Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 20.0,
              bottom: 20.0,
            ),
            child: PhysicsBox(
              boxPosition: 0.5,
            ),
          ),
        ),
      );
}

class PhysicsBox extends StatefulWidget {
  final boxPosition;

  PhysicsBox({this.boxPosition = 0.0});
  createState() => BoxState();
}

class BoxState extends State<PhysicsBox> with TickerProviderStateMixin {
  double boxPosition;
  double boxPositionOnStart;

  Offset startOffset; //Initial points of the box
  Offset currentOffset; //Actual area where user is draging around

  AnimationController controller;

  /// A SpringSimulation where the value of [x] is guaranteed to have exactly the
  /// end value when the simulation isDone().
  ScrollSpringSimulation simulation;

  @override
  initState() {
    super.initState();

    boxPosition = widget.boxPosition;

    ///TODO: play with the values
    simulation = ScrollSpringSimulation(
      SpringDescription(damping: 1.0, mass: 1.0, stiffness: 0.0),
      0.0,
      1.0,
      0.0, //velocity: at rest
    );

    controller = AnimationController(vsync: this)
      ..addListener(() {
        //Printing out position of our object
        print('${simulation.x(controller.value)}');
      });
  }

  build(context) => GestureDetector(
        onPanStart: startDrag,
        onPanUpdate: onDrag,
        onPanEnd: endDrag,
        child: CustomPaint(
          painter: BoxPainter(
            color: BOX_COLOR,
            boxPosition: boxPosition,
            boxPositionOnStart: boxPositionOnStart ?? boxPosition,
            touchPoint: currentOffset,
          ),
          child: Container(),
        ),
      );

// Calculate the inital touch position (startOffset) which will be used inside your dragMethod
  void startDrag(DragStartDetails details) {
    //Taking our widget (CustomPaint) and converting it into something that can be rendered
    //into co-ordinate plane
    startOffset = (context.findRenderObject() as RenderBox)
        .globalToLocal(details.globalPosition);

    boxPositionOnStart = boxPosition;
  }

//Find currentTouch position (it will be updated as long as user is draging her finger)
//And the update the box position (range: 0.0 -> 1.0)
  void onDrag(DragUpdateDetails details) {
    setState(() {
      currentOffset = (context.findRenderObject() as RenderBox)
          .globalToLocal(details.globalPosition);

      final dragVelocity = startOffset.dy - currentOffset.dy;
      final normalizedDragVelocity =
          (dragVelocity / context.size.height).clamp(-1.0, 1.0);
      print("Drag Velocity = $dragVelocity");
      print("NormalizedDragVelocity = $normalizedDragVelocity");

      boxPosition =
          (boxPositionOnStart + normalizedDragVelocity).clamp(0.0, 1.0);
      print("BoxPosition = $boxPosition");
    });
  }

  void endDrag(DragEndDetails details) {
    setState(() {
      startOffset = null;
      currentOffset = null;
      boxPositionOnStart = null;
    });
  }
}

class BoxPainter extends CustomPainter {
  final double boxPosition;
  final double boxPositionOnStart;

  final Color color;

  final Offset touchPoint;

  final Paint boxPaint; // Main paint Style and color
  final Paint dropPaint; // Paint color that will pop in if we run in a problem

  BoxPainter({
    this.boxPosition = 0.0,
    this.boxPositionOnStart = 0.0,
    this.color = Colors.grey,
    this.touchPoint,
  })  : boxPaint = Paint(),
        dropPaint = Paint() {
    boxPaint.color = Colors.red;
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 5.0;
    dropPaint.color = Colors.red;
    dropPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    print("Paint being called");

    canvas.clipRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    final boxValueY = size.height - (size.height * boxPosition);
    final prevBoxValueY = size.height - (size.height * boxPositionOnStart);

    // final midPointY = ((boxValueY - prevBoxValueY) * 1 + prevBoxValueY)
    //     .clamp(0.0, size.height);

    final midPointY = boxValueY.clamp(0.0, size.height);

    Point topLeft, topMid, topRight;

    //It will help use to drag the box with finger drag as well. (kind of illusion)
    //left = Point(-100.0, prevBoxValueY);

    // opposite ^ :
    topLeft = Point(0.0, prevBoxValueY);

    // right = Point(size.width + 50.0,
    //     prevBoxValueY); //+50 to extend right from outside the screen

    topRight = Point(size.width, prevBoxValueY);

    //  Wherever you will touch, the curve will be displaed in the center-top of the box
    if (null != touchPoint) {
      topMid = Point(touchPoint.dx, midPointY);
    } else {
      topMid = Point(size.width / 2, midPointY);
    }

    // Used to represent actual front(top) edge of the box
    // If user is pulling up -> Arc: Convex
    // If user is pulling down -> Arc: Concave
    final path = Path();

    //Make a path form top left to mid of left
    path.moveTo(topMid.x, topMid.y);

    //Left curve:
    //A curve which is initial point of
    //Move the curve to Left side
    //(starting from top of middle point to top-left of the box)
    //First to cooridnates are the control points
    path.quadraticBezierTo(topMid.x - 100, topMid.y, topLeft.x, topLeft.y);
    //path.quadraticBezierTo(topLeft.x - 100, topMid.y, topLeft.x, topLeft.y);

    //Top left to Bottom Left of the box
    path.lineTo(0.0, size.height);

    //Then we move back to the middle
    path.moveTo(topMid.x, topMid.y);

    //Middle to Bottom right of the box
    path.lineTo(size.width, size.height);

    //Then we move back to the middle
    path.moveTo(topMid.x, topMid.y);

    //Create a curve to the right
    path.quadraticBezierTo(topMid.x + 100, topMid.y, topRight.x, topRight.y);

    //To right-corner
    path.lineTo(size.width, size.height);

    // Line, starting from bottom left corner to bottom left corner
    path.lineTo(0.0, size.height);

    // that '/' line from bototm left ot middle is being created automatically

    path.close();

    canvas.drawPath(path, boxPaint);

    //if above doesn't work out.
    canvas.drawCircle(Offset(topRight.x, topRight.y), 10.0, dropPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegage) {
    //perpetually returnign true
    return true;
  }
}
