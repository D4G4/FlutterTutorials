import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';

const WEBVIEW_PATH = "/webview";

class MyApp extends StatelessWidget {
  static String url = "https://google.com";
  @override
  Widget build(context) => MaterialApp(
        title: "Webview Example",
        theme: ThemeData.dark(),
        routes: {
          "/": (_) => Home(),
          WEBVIEW_PATH: (_) => WebviewScaffold(
                url: url,
                appBar: AppBar(title: Text("Inside WebView")),
                withJavascript: true,
                withLocalStorage: true,
                withZoom: true,
                scrollBar: true,
                userAgent: "Mozilla",
              )
        },
      );
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String url;
  final webView = FlutterWebviewPlugin();
  TextEditingController controller = TextEditingController(text: MyApp.url);

  @override
  void initState() {
    super.initState();

    //Because webView is on second page, we want it closed
    webView?.close();
    controller.addListener(() {
      url = controller.text;
    });
  }

  @override
  void dispose() {
    webView.dispose();
    controller.dispose();
    super.dispose();
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
              child: TextField(
                controller: controller,
              ),
            ),
            RaisedButton(
              child: Text("Open WebView"),
              onPressed: () {
                Navigator.of(context).pushNamed(WEBVIEW_PATH);
              },
            )
          ],
        ),
      ),
    );
  }
}
