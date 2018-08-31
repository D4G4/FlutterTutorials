import 'package:flutter/material.dart';
import 'package:inherited_widgets/screens/auth_screen.dart';
import 'package:inherited_widgets/screens/home_screen.dart';

class AppRootWidget extends StatefulWidget {
  @override
  createState() => AppRootWidgetState();
}

class AppRootWidgetState extends State<AppRootWidget> {
  ThemeData get _themeData => ThemeData(
      primaryColor: Colors.cyan,
      accentColor: Colors.indigo,
      scaffoldBackgroundColor: Colors.grey[300]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inherited',
      debugShowCheckedModeBanner: false,
      theme: _themeData,
      routes: {
        '/': (BuildContext context) => HomeScreen(),
        '/auth': (BuildContext context) => AuthScreen()
      },
    );
  }
}
