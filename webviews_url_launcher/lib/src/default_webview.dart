import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

const URL = "https://steemit.com/";

class MyApp extends StatelessWidget {
  @override
  Widget build(context) => MaterialApp(
        title: "Webview Example",
        theme: ThemeData.dark(),
        home: Home(),
      );
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      print('can laun $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WebView")),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(URL),
            ),
            RaisedButton(
              child: Text("Open link"),
              onPressed: () {
                launchURL(URL);
              },
            )
          ],
        ),
      ),
    );
  }
}
