import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part1_page_reveal/main_material_page_revealer.dart';
import 'package:just_flutteringgggg/part2_hidden_drawer/main_hidden_drawer.dart';
import 'package:just_flutteringgggg/part3_egg_timer/main_egg_timer.dart';
import 'package:just_flutteringgggg/part4_music_player/main_music_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Just Flutteringgggg',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MusicPlayer());
  }
}
