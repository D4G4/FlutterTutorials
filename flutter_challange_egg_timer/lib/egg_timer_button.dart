part of 'main.dart';

class EggTimerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FlatButton(
        splashColor: const Color(0x22000000),
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Icon(
                  Icons.pause,
                  color: Colors.black,
                ),
              ),
              Text(
                'Pause',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  letterSpacing: 3.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      );
}
