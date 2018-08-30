import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Flutter Shared_Prefs Example'),
      ),
      body: Home(),
    ));
  }
}

class Home extends StatefulWidget {
  @override
  createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<SharedPreferences> _sPref = SharedPreferences.getInstance();

  final TextEditingController controller = TextEditingController();

  List<String> listOne, listTwo;

  @override
  void initState() {
    super.initState();
    listOne = [];
    listTwo = [];
  }

  @override
  Widget build(BuildContext context) {
    getStrings();
    return Center(
        child: ListView(
      children: <Widget>[
        TextField(
          onSubmitted: (value) => addString(),
          controller: controller,
          decoration: InputDecoration(hintText: 'Type in somehting...'),
        ),
        RaisedButton(
          padding: EdgeInsets.only(top: 5.0),
          child: Text('Submit'),
          onPressed: addString,
        ),
        RaisedButton(
          padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
          child: Text('Clear everything'),
          onPressed: clearItems,
        ),
        Flex(
          direction: Axis.vertical,
          children: listTwo == null
              ? []
              : listTwo
                  .map((String s) => Dismissible(
                        key: Key(s),
                        onDismissed: (DismissDirection direction) {
                          updateStrings(s);
                        },
                        child: Center(child: ListTile(title: Text(s))),
                      ))
                  .toList(),
        )
      ],
    ));
  }

  Future<Null> updateStrings(String str) async {
    final SharedPreferences preferences = await _sPref;
    preferences.setStringList('list', listOne);
    setState(() {
      listOne.remove(str);
    });
  }

  Future<Null> addString() async {
    if (controller.text.isEmpty) {
      return null;
    }
    final SharedPreferences prefs = await _sPref;
    listOne.add(controller.text);
    prefs.setStringList('list', listOne);
    setState(() {
      controller.text = '';
    });
  }

  Future<Null> clearItems() async {
    final SharedPreferences preferences = await _sPref;
    preferences.clear();

    setState(() {
      listOne = [];
      listTwo = [];
    });
  }

  Future<Null> getStrings() async {
    final SharedPreferences prefs = await _sPref;
    listTwo = prefs.getStringList('list');
    setState(() {});
  }
}
