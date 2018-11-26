import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part1_page_reveal/main_material_page_revealer.dart';
import 'package:just_flutteringgggg/part2_hidden_drawer/main_hidden_drawer.dart';
import 'package:just_flutteringgggg/part3_egg_timer/main_egg_timer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Just Flutteringgggg',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: EggTimer());
  }
}
