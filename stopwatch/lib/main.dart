import 'package:flutter/material.dart';
import 'timer_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) => MaterialApp(
      showPerformanceOverlay: false,
      title: 'Stopwatch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Stopwatch')),
        body: Container(child: TimePage()),
      ));
}
