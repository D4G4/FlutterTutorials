import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:t48_scoped_model_advanced/model.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scoped Model MultiPage demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: DefaultTabController(
        length: 2,
        child: ScopedModel<AppModel>(
          model: AppModel(),
          child: Scaffold(
              appBar: AppBar(
                title: Text("ScopedModel demo"),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.home),
                      text: "Home Page",
                    ),
                    Tab(
                      icon: Icon(Icons.screen_rotation),
                      text: "Display",
                    )
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  HomePage(),
                  DisplayPage() /*  */
                ],
              )),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  createState() => HomeState();
}

class HomeState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
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
          )
        ],
      ),
    );
  }
}

class DisplayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => Column(
              children: model.items
                  .map((item) => Dismissible(
                        key: Key(item.hashCode.toString()),
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              item.name,
                              style: TextStyle(fontSize: 20.0),
                            )),
                        onDismissed: (DismissDirection direction) {
                          model.deleteItem(item);
                        },
                      ))
                  .toList(),
            ),
      ),
    );
  }
}
