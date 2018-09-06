import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:t26_scoped_model_pattern/model/app_model.dart';

class Home extends StatelessWidget {
  final AppModel appModelOne = AppModel();
  final AppModel appModelTwo = AppModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Basic Counter'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ScopedModel<AppModel>(
              model: appModelOne,
              child: Counter(
                counterName: "App Model One",
              ),
            ),
            ScopedModel<AppModel>(
              model: appModelTwo,
              child: Counter(
                counterName: "App Model One",
              ),
            ),
          ],
        ));
  }
}

//Now our ScopedModelDescendant will try to find the nearest AppModel
//which is in our case present in the Scaffold defined above
class Counter extends StatelessWidget {
  final String counterName;
  Counter({this.counterName});

  @override
  build(context) {
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('$counterName'),
                Text(
                  model.count.toString(),
                  style: Theme.of(context).textTheme.display1,
                ),
                ButtonBar(
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
              ],
            ));
  }
}
