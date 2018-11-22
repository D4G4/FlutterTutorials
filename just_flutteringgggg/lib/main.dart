import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part1_page_reveal/material_page_revealer.dart';
import 'package:just_flutteringgggg/part_2_hidden_drawer/hidden_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Just Flutteringgggg',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HiddenDrawer());
  }
}
