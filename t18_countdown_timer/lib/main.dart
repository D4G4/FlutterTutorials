import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MaterialApp(
    theme: ThemeData(
      canvasColor: Colors.blueGrey,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      accentColor: Colors.pinkAccent,
      brightness: Brightness.dark,
    ),
    home: MyApp()));

class MyApp extends StatefulWidget {
  createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 08));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // TODO: implement build
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Align(
                  alignment: FractionalOffset.center,
                  child: AspectRatio(
                    aspectRatio: 1.4,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: controller,
                            builder:
                                (BuildContext builderContext, Widget widget) {
                              return CustomPaint(
                                painter: TimerPainter(
                                  animation: controller,
                                  backgroundColor: Colors.green,
                                  progressColor: themeData.indicatorColor,
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Count Down",
                                style: themeData.textTheme.subhead,
                              ),
                              AnimatedBuilder(
                                animation: controller,
                                builder: (context, widget) {
                                  return Text(
                                    timerString,
                                    style: themeData.textTheme.display4,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (context, widget) {
                            return Icon(controller.isAnimating
                                ? Icons.pause
                                : Icons.play_arrow);
                          },
                        ),
                        onPressed: () {
                          if (controller.isAnimating)
                            controller.stop();
                          else
                            controller.reverse(
                                from: controller.value == 0.0
                                    ? 1.0
                                    : controller.value);
                        },
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.progressColor,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = progressColor;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawCircle(size.center(Offset.zero), size.width, paint);
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        progressColor != old.progressColor;
  }
}
