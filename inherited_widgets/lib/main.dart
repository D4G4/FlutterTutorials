import 'package:flutter/material.dart';
import 'package:inherited_widgets/app_root_widget.dart';
import 'package:inherited_widgets/app_state_container.dart';

void main() => runApp(new AppStateContainer(
      child: AppRootWidget(),
    ));
