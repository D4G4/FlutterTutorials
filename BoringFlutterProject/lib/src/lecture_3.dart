import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:boring_flutter_project/source_gen_code__parsers/json_parsing.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formatter = DateFormat("MM-dd-yyyy");
  List<int> _ids = [
    17775906,
    17785162,
    17787275,
    17789456,
    17780127,
    17794509,
    17790031,
    17788060,
    17795143
  ];

  Future<Article> _getArticle(int id) async {
    final url = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final response2 = await http.get(url);
    if (response2.statusCode == 200) {
      return parseArticle(response2.body);
    }
  }

  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _ids
            .map(
              (id) => FutureBuilder<Article>(
                  future: _getArticle(id),
                  builder: (buildContext, AsyncSnapshot<Article> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return makeArticle(snapshot.data, buildContext);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
            .toList(),
      ),
    );
  }

  Widget makeArticle(Article obj, BuildContext buildContext) {
    String time =
        formatter.format(DateTime.fromMicrosecondsSinceEpoch(obj.time));

    return Padding(
        key: Key('${obj.hashCode}'),
        padding: const EdgeInsets.all(15.0),
        child: ExpansionTile(
            initiallyExpanded: false,
            backgroundColor: Colors.pink[50],
            title: Text('${obj.hashCode}\n${obj.title}',
                style: const TextStyle(fontSize: 20.0)),
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('${obj.score} comments'),
                    Text('$time'),
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
