import 'package:flutter/material.dart';
import 'package:built_value_tutorial/models/reddit.dart';
import 'package:built_value_tutorial/models/api.dart' as api;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Post> _posts = [];

  void initState() {
    super.initState();

    //getData();
  }

  void getData() {
    api.getReddit().then((posts) {
      setState(() {
        _posts = posts;
      });
    });
  }

  List<Widget> buildListTiles() => _posts
      .map((post) => ListTile(
            leading: CircleAvatar(
              child: Image.network(
                '${!post.thumbnail.contains(".jpg") ? "http://via.placeholder.com/300" : post.thumbnail}',
                scale: 0.2,
              ),
            ),
            title: Text(post.title),
            subtitle: Text('Subreddit: ${post.subreddit}'),
            trailing: Text('-${post.author}'),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("")),
        body: Container(
          color: Colors.red,
          margin: EdgeInsets.all(30.0),
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              api.getReddit().then((posts) {
                setState(() {
                  _posts = posts;
                });
              });
            },
            //child: ListView(children: buildListTiles()),
            child: AnimatedCrossFade(
              duration: Duration(milliseconds: 2000),
              // firstChild: Center(child: Text('Pull to refresh')),
              firstChild: const FlutterLogo(
                style: FlutterLogoStyle.horizontal,
                size: 100.0,
              ),
              secondChild: ListView(children: buildListTiles()),
              crossFadeState: _posts.isNotEmpty
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ));
  }
}
