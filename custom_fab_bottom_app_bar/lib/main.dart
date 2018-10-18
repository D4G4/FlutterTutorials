import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Bottom App Bar example'),
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
        appBar: AppBar(
          title: Text('Bottom AppBar example'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            )
          ],
        ),
        body: Container(),
        floatingActionButton: CustomFab(
          onPressed: () {},
          child: Icon(Icons.healing),
          color: Colors.lightBlue,
          notchMargin: 4.0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: MyBottomBar(
          color: Colors.green,
          hasNotch: false,
          notchMargin: 5.0,
        ),
      );
}

class MyBottomBar extends StatelessWidget {
  final Color color;
  final bool hasNotch;
  final double notchMargin;

  MyBottomBar({this.color, this.hasNotch, this.notchMargin});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: color,
      //shape: hasNotch ? CircularNotchedRectangle() : null,
      notchMargin: notchMargin ?? 2.0, //coalescing operator
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => Drawer(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.search),
                              title: Text('Search App'),
                            ),
                            ListTile(
                              leading: Icon(Icons.rotate_right),
                              title: Text('Rotate App'),
                            ),
                          ],
                        ),
                      ),
                ),
          ),
          Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }
}

class CustomFab extends StatefulWidget {
  final Widget child;
  final double notchMargin;
  final VoidCallback onPressed;
  final Color color;

  CustomFab({this.child, this.notchMargin: 8.0, this.onPressed, this.color});

  @override
  CustomFabState createState() => CustomFabState();
}

class CustomFabState extends State<CustomFab> {
  VoidCallback _notchChange;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.color,
      shape: CustomBorder(),
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          width: 55.0,
          height: 55.0,
          child: IconTheme.merge(
              data:
                  IconThemeData(color: Theme.of(context).accentIconTheme.color),
              child: widget.child),
        ),
      ),
      elevation: 5.0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _notchChange =
    //     Scaffold.setFloatingActionButtonNotchFor(context, computeNotch);
  }

  @override
  void deactivate() {
    if (_notchChange != null) {
      _notchChange();
    }
    super.deactivate();
  }

  Path computNotch(Rect appBar, Rect fab, Offset start, Offset end) {
    final Rect marginFab = fab.inflate(widget.notchMargin);

    if (!appBar.overlaps((marginFab))) return Path()..lineTo(end.dx, end.dy);

    /// Returns a new rectangle that is the intersection of the given
    /// rectangle and this rectangle. The two rectangles must overlap
    /// for this to be meaningful. If the two rectangles do not overlap,
    /// then the resulting Rect will have a negative width or height.
    final Rect intersection =
        marginFab.intersect(appBar); //From top of app bar till notch

    final double notchCenter = intersection.height *
        (marginFab.height / 2.0) /
        (marginFab.width / 2.0);

    return Path()
      ..lineTo(
          marginFab.center.dx - notchCenter, appBar.top) //From center to left
      ..lineTo(marginFab.left + marginFab.width / 2.0,
          marginFab.bottom) //to bottom center
      ..lineTo(marginFab.center.dx + notchCenter, appBar.top) //to top right
      ..lineTo(end.dx, end.dy); //just ends the actual notch
  }
}

class CustomBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets
      .only(); //Compute the dimensions on the basis of EdgeInsets of the actual shape.

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top) //top-center
      ..lineTo(rect.right, rect.top + rect.height / 2.0) //right
      ..lineTo(rect.left + rect.width / 2.0, rect.bottom) //bottom
      ..lineTo(rect.left, rect.top + rect.height / 2.0) //left
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return null;
  }
}
