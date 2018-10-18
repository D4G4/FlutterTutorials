import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TabScrollControllers',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'TabAndScrollController'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollViewController;

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (context, bool boxIsScrolled) => <Widget>[
              SliverAppBar(
                title: Text('Tab Controller Example'),
                pinned:
                    true, //Whether some of it should be visible or not. (False if not)
                floating: true,
                snap: true,
                forceElevated: boxIsScrolled,
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: 'Home',
                      icon: Icon(Icons.home),
                    ),
                    Tab(
                      text: 'Example Page',
                      icon: Icon(Icons.help),
                    )
                  ],
                  controller: _tabController,
                ),
              )
            ],
        body: TabBarView(
          children: <Widget>[
            PageOne(),
            PageTwo(),
          ],
          controller: _tabController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.control_point),
        onPressed: () {
          _tabController.animateTo(1,
              curve: Curves.bounceInOut,
              duration: Duration(milliseconds: 1000));

          // _scrollViewController.animateTo(
          //     _scrollViewController.position.minScrollExtent,
          //     duration: Duration(milliseconds: 1000),
          //     curve: Curves.decelerate);

          _scrollViewController
              .jumpTo(_scrollViewController.position.minScrollExtent);
        },
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  build(context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset('assets/photos/wallpaper_1.jpg', width: 200.0),
            Image.asset('assets/photos/wallpaper_2.jpg', width: 200.0),
            Image.asset('assets/photos/wallpaper_3.jpg', width: 200.0)
          ],
        ),
      );
}

class PageTwo extends StatelessWidget {
  @override
  build(context) => ListView.builder(
        itemExtent: 250.0,
        itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(10.0),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(5.0),
                color: index % 2 == 0 ? Colors.cyan : Colors.deepOrange,
                child: Center(
                    child: Text('${index.toString()}',
                        style: TextStyle(fontSize: 20.0, color: Colors.white))),
              ),
            ),
      );
}

///buld() _MyHomePageState
///
// @override
// Widget build(BuildContext context) {
// return DefaultTabController(   //You don't have to provide any custom Controller
//     length: 2,
//     child: Scaffold(
//       appBar: new AppBar(
//         title: new Text(widget.title),
//         bottom: TabBar(
//           tabs: <Widget>[
//             Tab(
//               text: "Home",
//               icon: Icon(Icons.home),
//             ),
//             Tab(
//               text: "Example Page",
//               icon: Icon(Icons.help),
//             )
//           ],
//         ),
//       ),
//       body: new Center(),
//     ));

//OR

// return Scaffold(
//     body: TabBarView(
//   controller: _tabController,
//   children: <Widget>[
//     PageOne(),
//     PageTwo(),
//   ],
// ));
