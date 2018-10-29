import 'package:flutter/material.dart';
import 'package:flutter_challange_weather_forecast_with_rain/genericWidgets/spinner_text.dart';

class ForecastAppBar extends StatelessWidget {
  final Function onDrawerArrowTap;
  final String selectedDay;

  ForecastAppBar({this.onDrawerArrowTap, this.selectedDay});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SpinnerText(
            text: selectedDay,
          ),
          Text(
            'Sacramento',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.0,
            ),
          )
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 35.0,
            color: Colors.white,
          ),
          onPressed: onDrawerArrowTap,
        )
      ],
    );
  }
}
