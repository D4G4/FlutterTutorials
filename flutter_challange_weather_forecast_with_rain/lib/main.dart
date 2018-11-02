import 'package:flutter/material.dart';

import 'package:flutter_challange_weather_forecast_with_rain/forecast/app_bar.dart';
import 'package:flutter_challange_weather_forecast_with_rain/genericWidgets/sliding_drawer.dart';
import 'package:flutter_challange_weather_forecast_with_rain/forecast/week_drawer.dart';
import 'package:flutter_challange_weather_forecast_with_rain/forecast/forecast.dart';
import 'package:flutter_challange_weather_forecast_with_rain/forecast/forecast_list.dart';
import 'package:flutter_challange_weather_forecast_with_rain/forecast/radial_list.dart';

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
  SlidingRadialListController slidingRadialListController;

  String selectedDay = 'Sunday\nOctober 28';

  @override
  void initState() {
    super.initState();
    openableController = OpenableController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() => setState(() {}))
      ..open();

    slidingRadialListController = SlidingRadialListController()..open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Forecast(
            radialList: forecastRadialList,
            slidingListController: slidingRadialListController,
          ),
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
                setState(() {
                  this.selectedDay = selectedDayText.replaceAll('\n', ',');
                });
                slidingRadialListController
                    .close()
                    .then((_) => slidingRadialListController.open());
                openableController.close();
              },
            ),
          )
        ],
      ),
    );
  }
}
