import 'package:flutter/material.dart';

class EggTimerButton extends StatelessWidget {
  final IconData icon;
  final String text;

  final Function() onPressed;

  EggTimerButton({@required this.icon, @required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) => FlatButton(
        splashColor: const Color(0x22000000),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Icon(
                  icon,
                  color: Colors.black,
                ),
              ),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  letterSpacing: 3.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      );
}
