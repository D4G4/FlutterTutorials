///`Sliver` :: fundamental building block :: Dynamic version of the Box Rendered Widgets (which rely on constriants)
///
///`Is a slice of a view-port` : half of the screen (Vert/Horiz) : consider as Sliver
///
///`Tend to change based on how view-port is laid out`
///  : In a ListView, it's the view that changes it's positon and nothe it's size, but with Slivers
///    you can have multiple pieces of the Sliver changing as the ScrollOffset is moving up and down.
///
///`Do not follow RenderBox protocol` :: Sliver Protocol : When they get laid out,
///   rather than getting `BoxConstraints`, they get
///    `SliverConstraint` -> computes `SliverGeometry` object.
///
/// [RenderBoxProtocl] :: A BoxConstraint obj which gives you a Size object.
///
/// `Slivers can have a single render box child` :: It will change it's SliverConstraints object
///   to a RenderBoxConstraint object to build the child.
///
/// `Lazily Constructed and Lazily construct their children` ::
///    behaviour can be changed based of the Delegates that we put inside a Sliver.
/// For instance, if a Sliver has 20 children and you only have 10 children on the screen,
/// at given time only those Widgets will be rendered at a given time

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'What are Slivers',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Sliver Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
          // appBar: AppBar(
          //   title: Text(widget.title),
          // ),
          body: CustomScrollView(
        slivers: <Widget>[
          //SliverAppBar is typically used inside CustomScrollView or some other type of Sliver based widget
          SliverAppBar(
            title: Text(
              'Sliver App Bar',
            ),
            floating: false,
            pinned: true,
            expandedHeight: 350.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.network(
                "http://lorempixel.com/output/abstract-q-c-1920-1080-8.jpg",
                fit: BoxFit.cover,
              ),
              title: Text("This is Title"),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 8.0),
            delegate: SliverChildBuilderDelegate(
              (context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.purple[100 * (index % 9)],
                  child: Text('Grid Item: $index'),
                );
              },
              childCount: 100,
            ),
          ),
          SliverFillViewport(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.redAccent,
                  child: Text(
                    'Sliver Fill ViewPort',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.limeAccent),
                  ),
                );
              },
              childCount: 1,
            ),
            viewportFraction: 1.0, //Spacing
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 8.0),
            delegate: SliverChildBuilderDelegate(
              (context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.purple[100 * (index % 9)],
                  child: Text('Grid Item: $index'),
                );
              },
              childCount: 101,
            ),
          ),
          SliverFillViewport(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.redAccent,
                  child: Text(
                    'Sliver Fill ViewPort',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.limeAccent),
                  ),
                );
              },
              childCount: 1,
            ),
            viewportFraction: 1.0, //Spacing
          ),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                    alignment: Alignment.center,
                    child: Text('List item: $index'),
                    color: Colors.indigo[100 * (index % 9)],
                    margin: const EdgeInsets.all(10.0),
                  ),
            ),
            // delegate: SliverChildListDelegate(
            //   [
            //     Container(
            //       child: Text('1'),
            //       color: Colors.green,
            //       margin: const EdgeInsets.all(10.0),
            //     ),
            //     Container(
            //       child: Text('2'),
            //       color: Colors.green,
            //       margin: const EdgeInsets.all(10.0),
            //     ),
            //     Container(
            //       child: Text('3'),
            //       color: Colors.green,
            //       margin: const EdgeInsets.all(10.0),
            //     ),
            //     Container(
            //       child: Text('4'),
            //       color: Colors.green,
            //       margin: const EdgeInsets.all(10.0),
            //     ),
            //     Container(
            //       child: Text('5'),
            //       color: Colors.green,
            //       margin: const EdgeInsets.all(10.0),
            //     ),
            //   ],
            // ),
          )
        ],
      ));
}
