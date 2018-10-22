import 'package:flutter_challange_egg_timer/egg_timer_button.dart';
import 'package:flutter/material.dart';

class EggTimerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
