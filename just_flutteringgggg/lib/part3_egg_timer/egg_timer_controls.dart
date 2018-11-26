import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part3_egg_timer/egg_timer_button.dart';

class EggTimerControls extends StatefulWidget {
  const EggTimerControls({
    Key key,
  }) : super(key: key);

  @override
  EggTimerControlsState createState() {
    return new EggTimerControlsState();
  }
}

class EggTimerControlsState extends State<EggTimerControls> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            EggTimerButton(
              icon: Icons.refresh,
              text: 'RESTART',
            ),
            EggTimerButton(
              icon: Icons.arrow_back,
              text: 'RESET',
            )
          ],
        ),
        EggTimerButton(
          icon: Icons.pause,
          text: 'PAUSE',
        )
      ],
    );
  }
}
