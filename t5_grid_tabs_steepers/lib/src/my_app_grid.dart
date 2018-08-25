import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text("Grid View")),
          body: TheGridView().build(),
        ));
  }
}

class TheGridView {
  Card makeGridCell(String name, IconData icon) {
    return Card(
      elevation: 1.0,
      color: Colors.blue[800],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Center(
            child: Icon(
              icon,
              semanticLabel: "Semantic label",
              color: Colors.pink[400],
              size: 100.0,
            ),
          ),
          Center(
              child: Text(
            name,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          )),
        ],
      ),
    );
  }

  GridView build() {
    return GridView.count(
        primary: true, //whether is should use PrimaryColor to paint itself
        padding: EdgeInsets.all(1.0),
        crossAxisCount: 2, //column count
        childAspectRatio: 1.0, //size of column
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 4.0,
        children: <Widget>[
          makeGridCell("Home", Icons.home),
          makeGridCell("Email", Icons.email),
          makeGridCell("Chat", Icons.chat),
          makeGridCell("New", Icons.new_releases),
          makeGridCell("Network", Icons.network_wifi),
          makeGridCell("Options", Icons.settings),
          makeGridCell("Call", Icons.call),
          makeGridCell("Message", Icons.message),
          makeGridCell("DND", Icons.do_not_disturb),
          makeGridCell("Silent", Icons.volume_off),
          makeGridCell("Viberation", Icons.vibration),
          makeGridCell("Volume Down", Icons.volume_down),
          makeGridCell("Volume mute", Icons.volume_mute),
          makeGridCell("Volume up", Icons.volume_up),
        ]);
  }
}
