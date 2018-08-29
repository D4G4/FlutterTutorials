import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  build(context) => MaterialApp(
        home: Scaffold(body: App()),
      );
}

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  Color caughtColor = Colors.green;

  ///Why stack?
  ///Stack allows us to essentially line up [Positioned] (widget) elements
  ///based on the size of this "box"
  ///Think of it as a huge box and we can choose two sides
  ///and then we can align a item with those two sides
  ///like we chose (Left and Top) or (Right and Bottom) or (Right and Left) ...
  build(context) => Stack(
        children: <Widget>[
          DragBox(Offset(0.0, 0.0), 'Box One', Colors.lime),
          DragBox(Offset(150.0, 0.0), 'Box Two', Colors.orange),
          dragBoxesHere(),
        ],
      );

  Widget dragBoxesHere() => Positioned(
        left: 100.0,
        bottom: 0.0,
        child: DragTarget(
          onAccept: (Color colorOfTheBox) {
            caughtColor = colorOfTheBox;
          },
          builder: (
            BuildContext dragTargetContext,
            List<dynamic> acceptedItems,
            List<dynamic> rejectedItems,
          ) {
            return Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  color: acceptedItems.isEmpty
                      ? caughtColor
                      : Colors.grey.shade200,
                ),
                child: Center(
                  child: Text('Drag here'),
                ));
          },
        ),
      );
}

class DragBox extends StatefulWidget {
  final Offset initPosition;
  final String label;
  final Color itemColor;

  DragBox(this.initPosition, this.label, this.itemColor);

  createState() => DragBoxState();
}

class DragBoxState extends State<DragBox> {
  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    position = widget.initPosition;
  }

  ///[Positioned] widget allows us to essentially position child element on stack
  @override
  build(context) => Positioned(
        left: position.dx,
        top: position.dy,
        child: Draggable(
          data: widget.itemColor,
          child: aBoxContainer(false),
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              position = offset;
            });
          },
          feedback: aBoxContainer(true),
        ),
      );

  Widget aBoxContainer(bool isMoving) => Container(
        width: isMoving ? 150.0 : 100.0,
        height: isMoving ? 150.0 : 100.0,
        color: isMoving ? widget.itemColor.withOpacity(0.5) : widget.itemColor,
        child: Center(
          child: Text(
            isMoving ? '${widget.label} + moving' : widget.label,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20.0,
            ),
          ),
        ),
      );
}
