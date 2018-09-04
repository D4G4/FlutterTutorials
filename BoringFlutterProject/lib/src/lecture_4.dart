import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:boring_flutter_project/source_gen_code__parsers/json_parsing.dart';
import 'package:intl/intl.dart';
import 'dart:collection';
import 'hn_bloc.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  final HackerNewsBloc bloc;
  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formatter = DateFormat("MM-dd-yyyy");

  int currentIndexOfNavBar = 0;

  @override
  initState() {
    super.initState();
    debugPrint("Init state");
  }

  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: LoadingInfo(widget.bloc.isLoading)),
      body: StreamBuilder<UnmodifiableListView<Article>>(
        stream: widget.bloc.articles,
        initialData: UnmodifiableListView<Article>([]),
        builder: (streamBuilderContext, snapshot) => ListView(
              children: snapshot.data
                  .map((article) => makeArticle(article, streamBuilderContext))
                  .toList(),
            ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndexOfNavBar,
        items: [
          BottomNavigationBarItem(
            title: Text("Top Stories"),
            icon: Icon(Icons.arrow_drop_up),
          ),
          BottomNavigationBarItem(
            title: Text("New Stories"),
            icon: Icon(Icons.new_releases),
          )
        ],
        onTap: (item) {
          switch (item) {
            case 0:
              //If you are using Sink
              //widget.bloc.storiesType.add(StoriesType.topStories);

              //If you are using StreamController
              widget.bloc.storiesType.add(StoriesType.topStories);
              break;
            case 1:
              //widget.bloc.storiesType.add(StoriesType.newStories);
              widget.bloc.storiesType.add(StoriesType.newStories);
              break;
          }
          setState(() {
            currentIndexOfNavBar = item;
          });
        },
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
                            duration: Duration(milliseconds: 500),
                          ));
                        }),
                    MaterialButton(
                      onPressed: () async {
                        final url = "http://${obj}";
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

class LoadingInfo extends StatefulWidget {
  final Stream<bool> _isLoading;
  LoadingInfo(this._isLoading);

  createState() => LoadingInfoState();
}

class LoadingInfoState extends State<LoadingInfo>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    //vsync take the track of whether this widget is in the view or not.
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) => animationOption2();

  Widget animationOption2() => StreamBuilder(
        stream: widget._isLoading,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            _controller.forward().then((_) => _controller.reverse());
            return FadeTransition(
              child: Icon(FontAwesomeIcons.hackerNewsSquare),
              opacity: Tween(begin: .1, end: 1.0).animate(
                  CurvedAnimation(curve: Curves.easeIn, parent: _controller)),
            );
          }
          _controller.reverse();
         return Container();
        },
      );

  Widget animationOption1() => StreamBuilder(
      stream: widget._isLoading,
      builder: (builderContext, AsyncSnapshot<bool> snapshot) {
        _controller.forward().then(
            (f) => _controller.reverse().then((_) => _controller.forward()));
        if (snapshot.hasData && snapshot.data) {
          return FadeTransition(
            child: Icon(FontAwesomeIcons.hackerNewsSquare),
            opacity: _controller,
          );
        } else
          return Container();
      });
}
