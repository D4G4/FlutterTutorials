import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

class YoutubeDemo extends StatefulWidget {
  createState() => YoutubeDemoState();
}

class YoutubeDemoState extends State<YoutubeDemo> {
  //final String MY_API_KEY = "AIzaSyDI4gpwDwETUs-f5i8K80im7Pdf9sC0dI0";
  final String MY_API_KEY = "AIzaSyDI4gpwDwETUs";

  TextEditingController urlController = TextEditingController();
  TextEditingController idController = TextEditingController();

  void initState() {
    super.initState();
  }

  void playYoutubeVideo() {
    FlutterYoutube.playYoutubeVideoByUrl(
        apiKey: MY_API_KEY,
        videoUrl: "https://www.youtube.com/watch?v=fhWaJi1Hsfo");
  }

  void playYoutubeVideoEdit() {
    var youtube = FlutterYoutube();

    youtube.onVideoEnded.listen((onData) {
      //Action when video playing is done
    });

    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: MY_API_KEY,
      videoUrl: urlController.text,
    );
  }

  void playYoutubeVideoIdEdit() {
    var youtube = FlutterYoutube();

    youtube.onVideoEnded.listen((onData) {
      //show snackbar
    });

    youtube.playYoutubeVideoById(
      apiKey: MY_API_KEY,
      videoId: idController.text,
    );
  }

  void playYoutubeVideoIdEditAuto() {
    var youtube = new FlutterYoutube();

    youtube.onVideoEnded.listen((onData) {
      //perform your action when video playing is done
    });

    youtube.playYoutubeVideoById(
        apiKey: "<API_KEY>", videoId: idController.text, autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Youtube")),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: urlController,
                  decoration: InputDecoration(labelText: "Enter Youtube Url"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new RaisedButton(
                    child: new Text("Play Video By Url"),
                    onPressed: playYoutubeVideoEdit),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new RaisedButton(
                    child: new Text("Play Default Video"),
                    onPressed: playYoutubeVideo),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextField(
                  controller: idController,
                  decoration: new InputDecoration(
                      labelText: "Youtube Video Id (fhWaJi1Hsfo)"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new RaisedButton(
                    child: new Text("Play Video By Id"),
                    onPressed: playYoutubeVideoIdEdit),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new RaisedButton(
                    child: new Text("Auto Play Video By Id"),
                    onPressed: playYoutubeVideoIdEditAuto),
              ),
            ],
          ),
        ));
  }
}
