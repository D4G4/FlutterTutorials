import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Websocket Channel',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  WebSocketChannel channel;
  TextEditingController controller;
  final List<Msg> msgs = [];

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect("ws://echo.websocket.org");
    controller = TextEditingController();
    channel.stream.listen((data) {
      Msg message = Msg(
        txt: data,
        controller: AnimationController(
            vsync: this, duration: Duration(milliseconds: 1000)),
      );
      setState(() {
        msgs.add(message);
      });
      message.controller.forward();
    });
  }

  void sendData() {
    if (controller.text.isNotEmpty) {
      channel.sink.add(controller.text); //Sending the data to the endpoint
      controller.text = "";
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    for (Msg msg in msgs) msg.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WebsocketDemo")),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Form(
              child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(labelText: "Send to webSocket")),
            ),
            Expanded(
              child: Column(
                children: msgs,
              ),
            )
            //Can convert stream to various widgets
            // StreamBuilder(
            //   stream: channel.stream,
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     return Container(
            //         child: Text(snapshot.hasData ? '${snapshot.data}' : 'no'));
            //   },
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: sendData,
      ),
    );
  }
}

class Msg extends StatelessWidget {
  final AnimationController controller;
  final String txt;

  Msg({@required this.txt, @required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(10.0),
        color: Colors.blueGrey,
        child: Text(
          txt,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
    );
  }
}
