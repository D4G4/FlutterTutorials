import 'package:flutter/material.dart';
import 'package:flutter_challange_weather_forecast_with_rain/forecast/background/background_with_rings.dart';

class Forecast extends StatelessWidget {
  Widget _temperatureText() => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(top: 150.0, left: 10.0),
          child: Text(
            '68',
            style: TextStyle(color: Colors.white, fontSize: 80.0),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BackgroundWithRings(),
        _temperatureText(),
      ],
    );
  }
}
