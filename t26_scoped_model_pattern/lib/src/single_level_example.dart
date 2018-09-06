import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:t26_scoped_model_pattern/model/app_model.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Counter'),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Counter"),
            //Sort of like StoreConnector in redux,

            //<AppModel> means: It tells the enclosing widget that it needs to find the closest version of "AppModel"
            //So it climbs up the widget tree and then it looks for this ScopedModel widget and it gets the AppModel
            //from the scoped model widget
            //
            //Unlike Redux, we do not need to have a converter
            ScopedModelDescendant<AppModel>(
                builder: (context, child, model) => Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        model.count.toString(),
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ))
          ]),
      floatingActionButton: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => ButtonBar(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: model.increment,
                ),
                IconButton(
                  icon: Icon(Icons.minimize),
                  onPressed: model.decrement,
                )
              ],
            ),
      ),
    );
  }
}
