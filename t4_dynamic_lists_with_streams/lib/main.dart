import 'package:flutter/material.dart';
import 'package:t4_dynamic_lists_with_streams/src/photo_list_state.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      title: "Photo streamer",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PhotoList(),
    );
  }
}
