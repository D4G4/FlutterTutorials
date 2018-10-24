import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //RenderBox renderBox;
  @override
  void initState() {
    // TODO: implement initStat
    //renderBox = context.findRenderObject();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          onHorizontalDragCancel: onHorizontalDragCancel,
          onHorizontalDragStart: onHorizontalDragStart,
          onHorizontalDragDown: onHorizontalDragDown,
          onHorizontalDragEnd: onHorizontalDragEnd,
          onHorizontalDragUpdate: onHorizontalDragUpdate,
          onVerticalDragCancel: onVerticalDragCancel,
          onVerticalDragStart: onVerticalDragStart,
          onVerticalDragDown: onVerticalDragDown,
          onVerticalDragEnd: onVerticalDragEnd,
          onVerticalDragUpdate: onVerticalDragUpdate,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  void onHorizontalDragCancel() {
    print('onHorizontalDragCancel ');
  }

  void onHorizontalDragStart(DragStartDetails details) {
    print('\nonHorizontalDragStart ');
    RenderBox renderBox = context.findRenderObject();
    var local = renderBox.globalToLocal(details.globalPosition);
    print(local.dx.toString() + "|" + local.dy.toString());
    print("\n");
  }

  void onHorizontalDragDown(DragDownDetails details) {
    print('onHorizontalDragDown ');
    RenderBox renderBox = context.findRenderObject();
    var local = renderBox.globalToLocal(details.globalPosition);
    print(local.dx.toString() + "|" + local.dy.toString());
    print("\n");
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    print('onHorizontalDragEnd ');
    print('Velocity ${details.primaryVelocity}');
    print("\n");
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    print('onHorizontalDragUpdate ');
    RenderBox renderBox = context.findRenderObject();
    var local = renderBox.globalToLocal(details.globalPosition);
    print(local.dx.toString() + "|" + local.dy.toString());
    print('Delta ${details.delta}');
    print("\n");
  }

  void onVerticalDragCancel() {
    print('onVerticalDragCancel ');
  }

  void onVerticalDragStart(DragStartDetails details) {
    print('onVerticalDragStart ');
    RenderBox renderBox = context.findRenderObject();
    var local = renderBox.globalToLocal(details.globalPosition);
    print(local.dx.toString() + "|" + local.dy.toString());
    print("\n");
  }

  void onVerticalDragDown(DragDownDetails details) {
    print('onVerticalDragDown ');
    RenderBox renderBox = context.findRenderObject();
    var local = renderBox.globalToLocal(details.globalPosition);
    print(local.dx.toString() + "|" + local.dy.toString());
    print("\n");
  }

  void onVerticalDragEnd(DragEndDetails details) {
    print('onVerticalDragEnd ');
    print('Velocity ${details.primaryVelocity}');
    print("\n");
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    print('onVerticalDragUpdate ');
    RenderBox renderBox = context.findRenderObject();
    var local = renderBox.globalToLocal(details.globalPosition);
    print(local.dx.toString() + "|" + local.dy.toString());
    print('Delta ${details.delta}');
    print("\n");
  }
}
