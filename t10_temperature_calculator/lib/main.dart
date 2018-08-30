/// So we can have a look at [TextField] [RadioButtons] [CheckBox]

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) => MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        home: TempApp(),
      );
}

class TempApp extends StatefulWidget {
  @override
  createState() => TempAppState();
}

class TempAppState extends State<TempApp> {
  double input;
  double output;
  bool fOrC; //Farenheit or Celsius

  @override
  initState() {
    super.initState();
    input = 0.0;
    output = 0.0;
    fOrC = true;
  }

  build(context) {
    TextField inputField = TextField(
      keyboardType: TextInputType.number,
      onChanged: (str) {
        try {
          input = double.parse(str);
        } catch (e) {
          input = 0.0;
        }
      },
      decoration: InputDecoration(
          labelText:
              "Input a Value in ${fOrC == false ? "Fahernheit" : "Celsius"}"),
    );

    AppBar appBar = AppBar(title: Text("Temperature Calculator"));

    Widget radua() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("F"),
            Radio<bool>(
              groupValue: fOrC,
              value: false,
              onChanged: (v) {
                setState(() {
                  fOrC = v;
                });
              },
            ),
            Text("C"),
            Radio<bool>(
              groupValue: fOrC,
              value: true,
              onChanged: (v) {
                setState(() {
                  fOrC = v;
                });
              },
            ),
          ],
        );

    Container tempSwitch = Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(children: <Widget>[
        Text("Fahrenheit or Celsius"),
        Switch(
          value: fOrC,
          onChanged: (_) {
            setState(() {
              fOrC = !fOrC;
            });
          },
        ),
        Checkbox(
          value: fOrC,
          onChanged: (e) {
            setState(() {
              fOrC = !fOrC;
            });
          },
        ),
        radua(),
      ]),
    );

    Container calButton = Container(
        child: RaisedButton(
      child: Text("Calculate"),
      onPressed: () {
        setState(() {
          fOrC == false
              ? output = (input - 32) * (5 / 9)
              : output = (input * 9 / 5) + 32;
        });
        AlertDialog dialog = AlertDialog(
            content: fOrC == false
                ? Text(
                    "${input.toStringAsFixed(3)}F : ${output.toStringAsFixed(3)}C")
                : Text(
                    "${input.toStringAsFixed(3)}C : ${output.toStringAsFixed(3)}F"));
        showDialog(context: context, child: dialog);
      },
    ));

    return Scaffold(
        appBar: appBar,
        body: Container(
            child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(children: <Widget>[inputField, tempSwitch, calButton]),
        )));
  }
}
