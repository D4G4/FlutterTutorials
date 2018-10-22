import 'package:flutter/material.dart';

import 'package:flutter_challange_egg_timer/egg_timer_time_display.dart';
part 'egg_timer_button.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Egg Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              EggeTimerTimeDisplay(),
              Expanded(
                child: Container(
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: AspectRatio(
                      aspectRatio: 1.0, //Width = Height
                      child: Container(color: Colors.purple, width: 50.0),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                child: Row(),
                color: Colors.green,
              ),
              EggTimerButton()
            ],
          ),
        ),
      ),
    );
  }
}
