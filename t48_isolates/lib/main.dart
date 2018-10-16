import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:isolate';
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Isolate Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> {
  List list =
      []; //to get the messages that we will be sending back to our isolates

  @override
  void initState() {
    super.initState();
    loadIsolate();
  }

  Future loadIsolate() async {
    ReceivePort receivePort =
        ReceivePort(); //Just a stream, which will flow into our application from the Isolate
    //Each ReceivePort has a corresponding send port and vice versa

    await Isolate.spawn(isolateEntry, receivePort.sendPort);

    SendPort sendPortOfIsolate = await receivePort.first;

    List message = await sendReceive(
        sendPortOfIsolate, "https://jsonplaceholder.typicode.com/comments");

    setState(() {
      list = message;
    });
  }

  static isolateEntry(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();

    sendPort.send(receivePort.sendPort);

    await for (var msg in receivePort) {
      String data = msg[0];
      SendPort replyPort = msg[1];

      http.Response response = await http.get(data);

      replyPort.send(json.decode(response.body));
    }
  }

  Future sendReceive(SendPort sendPort, message) {
    ReceivePort responsePort = ReceivePort();

    sendPort.send([message, responsePort.sendPort]);
    return responsePort.first;
  }

  Widget loadData() {
    if (list.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.all(5.0),
              child: Text('Item: ${list[index]["body"]}'));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Isolates")),
      body: loadData(),
    );
  }
}
