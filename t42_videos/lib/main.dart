import 'package:flutter/material.dart';

import 'package:t42_videos/src/video_from_asset.dart';
import 'package:t42_videos/src/video_from_network.dart';
import 'package:t42_videos/src/video_from_youtube.dart';
import 'package:t42_videos/src/video_from_stream.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) => MaterialApp(
        title: 'Videos Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: VideoFromStream(title: 'Youtube, Local and Network'),
      );
}
