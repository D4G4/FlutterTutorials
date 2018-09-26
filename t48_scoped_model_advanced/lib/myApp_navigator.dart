import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:t48_scoped_model_advanced/model.dart';

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    HomePage.route: (BuildContext context) => HomePage(),
    DisplayPage.route: (BuildContext context) => DisplayPage()
  };
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
        model: AppModel(),
        child: MaterialApp(
          title: 'Scoped Model MultiPage demo',
          theme: ThemeData(primarySwatch: Colors.green),
          home: HomePage(),
          routes: routes,
        ));
  }
}

class HomePage extends StatefulWidget {
  static final String route = "Home-Page";
  @override
  createState() => HomeState();
}

class HomeState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: controller,
              ),
            ),
            //This will go and try to find the nearest AppModel widget and fetch the data from it
            ScopedModelDescendant<AppModel>(
              builder: (context, child, AppModel model) => RaisedButton(
                    child: Text("Add item"),
                    onPressed: () {
                      Item item = Item(controller.text);
                      model.addItem(item);
                      setState(() => controller.text = '');
                    },
                  ),
            ),
            RaisedButton(
              child: Text('Display Page'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class DisplayPage extends StatelessWidget {
  static final String route = "Display-page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Page'),
        actions: <Widget>[
          FlatButton(
            child: Text("Back home"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          )
        ],
      ),
      body: Container(
        child: ScopedModelDescendant<AppModel>(
          builder: (context, child, model) => Column(
                children: model.items
                    .map((item) => Dismissible(
                          key: Key(item.hashCode.toString()),
                          child: ExpansionTile(
                            backgroundColor: Colors.blueGrey,
                            initiallyExpanded: true,
                            title: Text(
                              item.name,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          onDismissed: (DismissDirection direction) {
                            model.deleteItem(item);
                          },
                        ))
                    .toList(),
              ),
        ),
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      ),
    );
  }
}
