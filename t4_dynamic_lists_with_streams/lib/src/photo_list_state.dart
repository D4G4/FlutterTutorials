import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class PhotoList extends StatefulWidget {
  @override
  createState() => PhotoListState();
}

class PhotoListState extends State<PhotoList> {
  StreamController<Photo> streamController;
  List<Photo> list = [];

  @override
  void initState() {
    super.initState();

    streamController = StreamController.broadcast();

//  Attach a listener to your StreamController
//  Whenever any event will occur, it will set the state and put the item into the list.
    streamController.stream.listen((photo) {
      debugPrint("\n-----------------------Got one---------------\n");
      debugPrint("${photo.toString()}");
      setState(() => list.add(photo));
    });
    load();
  }

  load() async {
    String url = "https://jsonplaceholder.typicode.com/photos";

    var client = http.Client();

    var request = http.Request('get', Uri.parse(url));

    var streamedResponse = await client.send(request);

    streamedResponse.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand(
            (e) => e) //Take each element from stream and put it into collection
        .map((map) => Photo.fromJsonMap(map))
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
      appBar: AppBar(
        title: Text("Photos Stream"),
      ),
      body: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => _makeElement(index),
        ),
      ),
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
