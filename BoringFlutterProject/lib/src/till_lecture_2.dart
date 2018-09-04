import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'dummy_article.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> _articles = fakeArticles;

  build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Builder(
          builder: (builderContext) {
            return RefreshIndicator(
              child: ListView(
                children: _articles
                    .map(
                        (articleObj) => makeArticle(articleObj, builderContext))
                    .toList(),
              ),
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 3));
                Scaffold
                    .of(builderContext)
                    .showSnackBar(SnackBar(content: Text("bka")));
                setState(() {
                  _articles.removeAt(0);
                });
              },
            );
          },
        ));
  }

  Widget makeArticle(Article obj, BuildContext buildContext) {
    return Padding(
        key: Key('${obj.hashCode}'),
        padding: const EdgeInsets.all(15.0),
        child: ExpansionTile(
            initiallyExpanded: false,
            backgroundColor: Colors.pink[50],
            title: Text('${obj.hashCode}\n${obj.text}',
                style: const TextStyle(fontSize: 20.0)),
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('${obj.score} comments'),
                    Text('${obj.time}'),
                    IconButton(
                        icon: Icon(
                          Icons.person_pin,
                          color: Colors.green[300],
                        ),
                        onPressed: () {
                          Scaffold.of(buildContext).showSnackBar(SnackBar(
                            content: Text('By ${obj.by}'),
                          ));
                        }),
                    MaterialButton(
                      onPressed: () async {
                        final url = "http://${obj.url}";
                        if (await urlLauncher.canLaunch(url)) {
                          urlLauncher.launch(url);
                        }
                      },
                      child: Icon(
                        Icons.open_in_browser,
                        color: Colors.deepOrangeAccent,
                      ),
                    )
                  ])
            ]));
  }
}
