import 'package:flutter/material.dart';

class EggTimerTimeDisplay extends StatefulWidget {
  _EggTimerTimeDisplayState createState() => _EggTimerTimeDisplayState();
}

class _EggTimerTimeDisplayState extends State<EggTimerTimeDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: Text(
          '15:23',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'BebasNeue',
            fontSize: 110.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 10.0,
          ),
        ),
      ),
    );
  }
}
