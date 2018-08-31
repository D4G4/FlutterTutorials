/// An [InheritedWidget] wrapped in a [StatefulWidget]
/// This makes the container a stateful widget that has the
/// ability to pass state all the way down the tree and
/// be updated with setState()
/// which would render all the ancestor widgets
/// that rely on the slice of state updated.

import 'package:flutter/material.dart';
import 'package:inherited_widgets/models/app_state.dart';

import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppStateContainer extends StatefulWidget {
  //  Your AppState is managed by the container
  final AppState appState;

  //  This widget is simply the root of the tree
  //  so it has to have a child!
  final Widget child;

  AppStateContainer({@required this.child, this.appState});

  ///  This creates a method on the AppState that's just like 'of' method
  ///  on MediaQueries, Theme, etc
  ///  `This is the secret to accessing your AppState all over your app`
  ///.data is [AppStateContainer] being passed to [_InheritedStateCotainer]
  ///
  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  AppState state;
  GoogleSignInAccount googleUser;
  final googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();

    if (widget.appState != null) {
      state = widget.appState;
    } else {
      state = AppState.loading();
      initUser();
    }
  }

  Future initUser() async {
    googleUser = await _ensureLoggedInOnStartup();
    if (googleUser == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      var firebaseUser = await logIntoFirebase();
    }
  }

  logIntoFirebase() async {
    if (googleUser == null) {
      googleUser = await googleSignIn.signIn();
    }

    FirebaseUser firebaseUser;
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      firebaseUser = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('Loggd in: ${firebaseUser.displayName}');
      setState(() {
        state.isLoading = false;
        state.user = firebaseUser;
      });
    } catch (err0r) {
      print(err0r);
      return null;
    }
  }

  Future<dynamic> _ensureLoggedInOnStartup() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) {
      user = await googleSignIn
          .signInSilently(); //this may be null if there isn't any previous user
    }
    googleUser = user;
    return user;
  }

  // So the WidgetTree is actually
  // AppStateContainer --> InheritedStateContainer --> The rest of your app
  build(context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

// This is likely all your InheritedWidget will ever need
class _InheritedStateContainer extends InheritedWidget {
  // The data is whatever this widget is passing down.
  final _AppStateContainerState data;

  /// InheritedWidgets are always just wrappers.
  /// So there has to be a child,
  /// Although Flutter just knows how to buld the Widget that's passed to it
  /// So you don't have to have a build method or anything
  _InheritedStateContainer(
      {Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);

  // Flutter automatically calls this method when any data in this widget is changed.
  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) => true;
}
