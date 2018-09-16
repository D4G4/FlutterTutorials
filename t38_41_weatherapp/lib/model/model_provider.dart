import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:t38_41_weatherapp/model/model_command.dart'; //Can be an InheritedWidget

class ModelProvider extends InheritedWidget {
  final ModelCommand modelCommand;

  ModelProvider({Key key, @required this.modelCommand, @required Widget child})
      : assert(modelCommand != null),
        super(key: key, child: child);

  //bcz it is an inherited widget
  @override
  bool updateShouldNotify(ModelProvider oldWidget) {
    return modelCommand != oldWidget.modelCommand;
  }

  static ModelCommand of(BuildContext context) {
    ModelProvider modelProvider =
        context.inheritFromWidgetOfExactType(ModelProvider) as ModelProvider;

    return modelProvider.modelCommand;
  }
}
