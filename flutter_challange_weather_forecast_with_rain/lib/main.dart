import 'package:flutter/material.dart';

import 'package:flutter_challange_weather_forecast_with_rain/forecast/app_bar.dart';
import 'package:flutter_challange_weather_forecast_with_rain/genericWidgets/sliding_drawer.dart';
import 'package:flutter_challange_weather_forecast_with_rain/forecast/week_drawer.dart';
import 'package:flutter_challange_weather_forecast_with_rain/forecast/forecast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  OpenableController openableController;
  String selectedDay = 'Sunday\nOctober 28';

  @override
  void initState() {
    super.initState();
    openableController = OpenableController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() => setState(() {}))
      ..open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Forecast(),
          Positioned(
            top: 5.0,
            left: 0.0,
            right: 0.0,
            child: ForecastAppBar(
              onDrawerArrowTap: openableController.open,
              selectedDay: selectedDay,
            ),
          ),
          SlidingDrawer(
            openableController: openableController,
            drawer: WeekDrawer(
              onDaySelected: (String selectedDayText) {
                openableController.close();
                setState(() {
                  this.selectedDay = selectedDayText.replaceAll('\n', ',');
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
