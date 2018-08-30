import 'package:flutter/material.dart';

void main() => runApp(StylingApp());

class StylingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  double beginZ = 10.0;
  double endZ = 1000.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 15));

    animation = Tween(begin: beginZ, end: endZ).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Styling App'),
        ),
        body: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
              color: Colors.black54,
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Transform(
                  transform: Matrix4.identity(),
                  child: Container(
                    width: 300.0,
                    height: 300.0,
                    //color: Colors.blueGrey[300],
                    decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: <Color>[
                            Color(0xffef5350),
                            Color(0x00ef5350),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(animation.value),
                        border: Border.all(
                            color: Colors.green, style: BorderStyle.solid),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.green[50],
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0),
                          BoxShadow(
                            color: Color(0x80000000), //Reddish
                            offset: Offset(0.0, 66.0),
                            blurRadius: 0.0, //Radius of blur outside the box
                          ),
                        ]),
                    alignment: Alignment.center,
                    child: Text(
                      "Styling Stuff",
                      style: TextStyle(
                        fontSize: 42.0,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
