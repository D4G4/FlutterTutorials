import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part4_music_player/colors.dart';
import 'package:just_flutteringgggg/part4_music_player/songs.dart';
import 'package:just_flutteringgggg/part4_music_player/bottom_controls.dart';

import 'dart:math';

class MusicPlayer extends StatefulWidget {
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
          color: const Color(0xFFDDDDDD),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
            color: const Color(0xFFDDDDDD),
          ),
        ],
        title: Text(''),
      ),
      body: Column(children: <Widget>[
        // Seekbar
        Expanded(
          child: Center(
            child: Container(
              width: 120.0,
              height: 120.0,
              child: RadialSeekBar(
                child: ClipOval(
                  clipper: CircleClipper(),
                  child: Image.network(
                    demoPlaylist.songs[1].albumArtUrl,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Visualizer
        Container(
          width: double.infinity,
          height: 125.0,
        ),

        // Song title, artist name and controls
        BottomControls()
      ]),
    );
  }
}

class RadialSeekBar extends StatefulWidget {
  final double trackWidth;
}

class CircleClipper extends CustomClipper<Rect> {
  @override
  bool shouldReclip(CircleClipper oldDelegate) {
    return true;
  }

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: min(size.width, size.height) / 2);
  }
}
