import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: themeData,
    home: Page1(),
  ));
}

final ThemeData themeData = ThemeData(
    canvasColor: Colors.white,
    accentColor: Colors.deepPurpleAccent,
    primaryColor: Colors.redAccent);

class Page1 extends StatelessWidget {
  final myFocusNode = FocusNode();
  @override
  build(BuildContext context) {
    FocusScope.of(context).requestFocus(myFocusNode);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.push(context, PageTwo());
              },
              child: Text(
                "Touch here to go to Page Two",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextFormField(
              //focusNode: myFocusNode,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Label text",
                  hintText: "Hint",
                  hintStyle: TextStyle(color: Colors.green)),
            ),
            TextField(
              focusNode: myFocusNode,
              cursorColor: Colors.green,
              style: TextStyle(
                color: Colors.orange,
              ),
              decoration: InputDecoration(
                  hintText: "Without any bottom line",
                  border: InputBorder.none),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                backgroundBlendMode: BlendMode.colorBurn,
                gradient: Gradient.lerp(
                    LinearGradient(
                        colors: [Colors.red, Colors.orange, Colors.pink]),
                    RadialGradient(colors: [Colors.blue, Colors.green]),
                    50.0),
                color: Colors.blue[800],
                border: Border.all(color: Colors.black, width: 4.0),
              ),
              child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                  decoration: InputDecoration(
                      hintText: 'Hint', hintStyle: TextStyle(color: Colors.red)
                      // border: InputBorder.none
                      )),
            )
          ],
        ),
      ),
    );
  }
}

///[MaterialPageRoute] allows use to essentially replace
///the entire screen with new Transition screen.
///Our [MyApp] state will replace in memory.
///We can set the `maintainState` property to `false`
///
///This `null` thus signifies that
///actual route is not gonna return anything.
///
///Building the page inside the contructor
///[builder] property of [MaterialPageRoute] (super constructor)
///
class PageTwo extends MaterialPageRoute<Null> {
  PageTwo()
      : super(
            builder: (BuildContext context) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 1.0,
                  title: Text("Page 2"),
                ),
                body: Center(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context, PageThree());
                    },
                    child: Text("Go to Page Three"),
                  ),
                )),
            maintainState: false);
}

class PageThree extends MaterialPageRoute<Null> {
  PageThree()
      : super(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Last Page!"),
              backgroundColor: Theme.of(context).accentColor,
              elevation: 2.0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            body: Center(
              child: MaterialButton(
                onPressed: () => Navigator.popUntil(
                    context, ModalRoute.withName(Navigator.defaultRouteName)),
                child: Text(
                  "Go home!",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          );
        });
}
