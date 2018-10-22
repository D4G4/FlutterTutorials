import 'package:flutter/material.dart';

class EggeTimerTimeDisplay extends StatefulWidget {
  @override
  _EggeTimerTimeDisplayState createState() => _EggeTimerTimeDisplayState();
}

class _EggeTimerTimeDisplayState extends State<EggeTimerTimeDisplay> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Text(
          '15:23',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 100.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 10.0,
              color: Colors.black,
              fontFamily: 'BebasNeue'),
        ),
      );
}
