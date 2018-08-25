import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StarWarsData extends StatefulWidget {
  @override
  createState() => StarWarsState();
}

class StarWarsState extends State<StarWarsData> with TickerProviderStateMixin {
  final String url = "https://swapi.co/api/starships";
  List data;

  Animation<int> _characterAnimation;

  int _stringIndex;

  static const List<String> _kStrings = const <String>[
    'Loading .............'
    ,'........'
    ,'........'
  ];

  String get _currentString => _kStrings[_stringIndex % _kStrings.length];

  Future<String> getSWData() async {
    Future.delayed(Duration(milliseconds: 5000)).then((_) {
      debugPrint("done with delayed");
      http.get(Uri.encodeFull(url),
          headers: {"Accept": "application/json"}).then((response) {
        setState(() {
          var responseBody = json.decode(response.body);
          data = responseBody['results'];
        });
        debugPrint("Succesfully fetched result");
        return "Success";
      }).catchError(() => "Failed!");
    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    performAnimation();
    this.getSWData();
  }

/// Create a list of animation for each character
/// Create a [AnimationController] and configure your animation characteristics
/// [StepTween] will also setup value of Animation
  performAnimation() async {
    AnimationController controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    setState(() {
      _stringIndex = _stringIndex == null ? 0 : _stringIndex + 1;
      debugPrint('StringIndex--->  $_stringIndex');
      _characterAnimation = StepTween(begin: 0, end: _currentString.length)
          .animate(
              CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    });

    await controller.forward();
    controller.dispose();
    if (data == null) performAnimation();
  }

  Widget loadingAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        (_stringIndex.isEven ? Icon(Icons.access_alarm) : Icon(Icons.alarm_add)),
        AnimatedBuilder(
          animation: _characterAnimation,
          builder: (BuildContext context, Widget child) {
            String text =
                _currentString.substring(0, _characterAnimation.value);
            debugPrint("String inside -> $text");
            return Center(
                child: Text(text,
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 45.0)));
          },
        ),
        //CircularProgressIndicator(),
        LinearProgressIndicator()
      ],
    );
  }

  @override
  build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Star Wars Starships"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: (data == null || data.length == 0)
            ? loadingAnimation()
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 10.0, top: 15.0),
                          child: Text(
                            data[index]['name'],
                            style: const TextStyle(
                                fontSize: 18.0, color: Colors.red),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Card(
                            child: Text(
                              data[index]['model'],
                              style: const TextStyle(fontSize: 24.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
                },
              ),
      );
}
