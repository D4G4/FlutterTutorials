import 'package:flutter/material.dart';
import 'fancy_fab.dart';

class AnimatedFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Only fab demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FabNotch")),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.add),
      // ),
      //floatingActionButton: FancyFab(),
      floatingActionButton: FloatingActionButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // bottomNavigationBar: BottomAppBar(
      //   shape: CircularNotchedRectangle(),
      //   color: Colors.green,
      //   child: Row(
      //     children: <Widget>[
      //       IconButton(
      //         icon: Icon(Icons.ac_unit),
      //         onPressed: () {},
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
