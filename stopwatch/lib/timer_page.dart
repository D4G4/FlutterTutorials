import 'package:flutter/material.dart';
import 'dart:async';

class ElapsedTime {
  final int hundereds;
  final int seconds;
  final int minutes;

  ElapsedTime({this.hundereds, this.seconds, this.minutes});
}

class Dependencies {
  final List<ValueChanged<ElapsedTime>> timeListeners =
      <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle =
      const TextStyle(fontSize: 90.0, fontFamily: "Bebas Neue");
  final Stopwatch stopwatch = Stopwatch();
  final int timeMillisecondsRefreshRate = 30;
}

class TimePage extends StatefulWidget {
  TimePage({Key key}) : super(key: key);

  @override
  createState() => TimePageState();
}

class TimePageState extends State<TimePage> {
  final Dependencies dependencies = new Dependencies();

  //Stopwatch stopwatch = dependencies.stopwatch; //Error: Only static members can be accessed in initializers
  Stopwatch stopwatch;

  @override
  void initState() {
    //Initializers are executed before the constructor,
    //but this is only allowed to be accessed after the call to the super constructor was completed.
    stopwatch = dependencies.stopwatch;

    super.initState();
  }

  void leftButtonPressed() {
    setState(() {
      if (stopwatch.isRunning) {
        print("${stopwatch.elapsedMilliseconds}");
      } else {
        stopwatch.reset();
      }
    });
  }

  void rightButtonPressed() {
    setState(() {
      if (stopwatch.isRunning) {
        stopwatch.stop();
      } else {
        stopwatch.start();
      }
    });
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
        const TextStyle(fontSize: 16.0, color: Colors.white);
    return FloatingActionButton(
        child: Text(
          text,
          style: roundTextStyle,
        ),
        onPressed: callback);
  }

  @override
  Widget build(BuildContext context) => TimeInheritedWidget(
        child: childWidget(),
        dependencies: dependencies,
      );

  Widget childWidget() => Column(
        children: <Widget>[
          Container(
            height: 200.0,
            //child: Center(child: TimerText(dependencies: dependencies)),
            child: Center(child: TimerText()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildFloatingButton(
                  stopwatch.isRunning ? "lap" : "reset", leftButtonPressed),
              buildFloatingButton(
                  stopwatch.isRunning ? "stop" : "start", rightButtonPressed),
            ],
          )
        ],
      );
}

class TimeInheritedWidget extends InheritedWidget {
  final Dependencies dependencies;
  TimeInheritedWidget({
    Key key,
    this.dependencies,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(TimeInheritedWidget oldWidget) {
    return true;
  }

  static TimeInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(TimeInheritedWidget);
  }
}

class TimerText extends StatefulWidget {
  TimerText();

  createState() => TimerTextState();
}

class TimerTextState extends State<TimerText> {
  TimerTextState();

  Stopwatch stopwatch;
  Timer timer;
  int milliseconds;

  Dependencies dependencies;

  @override
  void initState() {
    dependencies = TimeInheritedWidget.of(context).dependencies;
    stopwatch = dependencies.stopwatch;
    timer = Timer.periodic(
        Duration(milliseconds: dependencies.timeMillisecondsRefreshRate),
        callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != stopwatch.elapsedMilliseconds) {
      milliseconds = stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();

      final ElapsedTime elapsedTime =
          ElapsedTime(hundereds: hundreds, seconds: seconds, minutes: minutes);
      for (final listener in dependencies.timeListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RepaintBoundary(
            child: SizedBox(
                height: 72.0,
                child: MinutesAndSeconds(
                  dependencies: dependencies,
                )),
          ),
          RepaintBoundary(
            child: SizedBox(
              height: 72.0,
              //child: Hundreds(dependencies: dependencies),
              child: Hundreds(),
            ),
          ),
        ],
      );
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});
  final Dependencies dependencies;

  //createState() => MinutesAndSecondsState(dependencies: dependencies);
  createState() => MinutesAndSecondsState();
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  //MinutesAndSecondsState({this.dependencies});
  //final Dependencies dependencies;
  Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;

  void initState() {
    dependencies = TimeInheritedWidget.of(context).dependencies;
    dependencies.timeListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsedTime) {
    if (elapsedTime.minutes != minutes || elapsedTime.seconds != seconds) {
      setState(() {
        minutes = elapsedTime.minutes;
        seconds = elapsedTime.seconds;
      });
    }
  }

  @override
  Widget build(context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return Text('$minutesStr:$secondsStr.', style: dependencies.textStyle);
  }
}

class Hundreds extends StatefulWidget {
  // final Dependencies dependencies;
  // Hundreds({this.dependencies});
  @override
  //createState() => HunderedsState(dependencies: dependencies);
  createState() => HunderedsState();
}

class HunderedsState extends State<Hundreds> {
  // final Dependencies dependencies;
  // HunderedsState({this.dependencies});
  Dependencies dependencies;

  int hundreds = 0;

  void initState() {
    dependencies = TimeInheritedWidget.of(context).dependencies;
    dependencies.timeListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsedTime) {
    if (elapsedTime.hundereds != hundreds) {
      setState(() {
        hundreds = elapsedTime.hundereds;
      });
    }
  }

  @override
  Widget build(context) {
    String hundredStr = (hundreds % 100).toString().padLeft(2, '0');
    return Text(hundredStr, style: dependencies.textStyle);
  }
}
