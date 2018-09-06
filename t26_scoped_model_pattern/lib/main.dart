import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:t26_scoped_model_pattern/model/app_model.dart';

import 'package:t26_scoped_model_pattern/src/single_level_example.dart'
    as singleLeveled;
import 'package:t26_scoped_model_pattern/src/multi_leveled_example.dart'
    as multiLeveled;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Counter Example',
        theme: ThemeData.dark(),
        // home: ScopedModel<AppModel>(
        //   //Any widget inside this widget gets access to AppModel
        //   model: AppModel(),
        //   child: multiLeveled.Home(),
        // ),
        home: multiLeveled.Home());
  }
}
