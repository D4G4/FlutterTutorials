import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


/// Our list will be dynamically sized
/// our [StreamController] will continuously receive data.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Photo Streamer',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: PhotoList());
  }
}

class PhotoList extends StatefulWidget {
  @override
  PhotoListState createState() => PhotoListState();
}

class PhotoListState extends State<PhotoList> {
  StreamController<Photo> streamController;

  List<Photo> list = [];

  @override
  void initstate() {
    super.initState();
    streamController =
        StreamController.broadcast(); //so that we can subscribe to this stream

    streamController.stream
        .listen((photoObj) => setState(() => list.add(photoObj)));

    createStream();
  }

  createStream() async{
    String url = "https://jsonplaceholds.typicode.com/photos";

    http.Client client = http.Client();

    http.Request request = http.Request('get', Uri.parse(url));

    http.StreamedResponse streamedResponse = await client.send(request);

    streamedResponse.stream
    .transform(utf8.decoder)
    .transform(json.decoder)
    .expand( (e) => e)  //Take each element from the stream and put them into a collection
    .map( (map) => Photo.fromJsonMap(map))
    .pipe(streamController);
  }

  @override
  void dispose() {
    super.dispose();
    streamController?.close();
    streamController = null;
  }

  @override
  build(context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Photo Stream")
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) => _makeElement(index)
        ),
      )
    );
  }

    Widget _makeElement(index) {
    if (index >= list.length) return null;
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Column(
            children: <Widget>[
              Image.network(
                list[index].url,
                scale: 0.5,
              ),
              Text(list[index].title)
            ],
          ),
        ));
  }
}

class Photo {
  final String title;
  final String url;

  Photo.fromJsonMap(Map map)
      : title = map['title'],
        url = map['url'];
}
