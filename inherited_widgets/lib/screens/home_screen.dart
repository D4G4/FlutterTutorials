import 'package:flutter/material.dart';
import 'package:inherited_widgets/app_state_container.dart';
import 'package:inherited_widgets/models/app_state.dart';
import 'package:inherited_widgets/screens/auth_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  AppState appState;

  Widget get _pageToDisplay {
    if (appState.isLoading) {
      return _loadingView;
    } else if (!appState.isLoading && appState.user == null) {
      return AuthScreen();
    } else {
      return _homeView;
    }
  }

//  Perform some animation here (decoupled)
  Widget get _loadingView => Center(
        child: CircularProgressIndicator(),
      );

  Widget get _homeView => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Logged In:',
              style: new TextStyle(
                fontSize: 18.0,
              ),
            ),
            new Text(
              appState.user.displayName,
              style: new TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      );

  @override
  build(context) {
    var container = AppStateContainer.of(context);
    appState = container.state;

    Widget body = _pageToDisplay;

    return Scaffold(
      appBar: AppBar(title: Text("Inherited test")),
      body: body,
    );
  }
}
