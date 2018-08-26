import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      title: "Input Boxes",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: InputBox(),
    );
  }
}

class InputBox extends StatefulWidget {
  createState() => InputBoxState();
}

class InputBoxState extends State<InputBox> {
  bool loggedIn = false;
  String _email, _username, _password;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  build(context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(title: Text("Form Example")),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: loggedIn == false ? showForm() : showPageIfLoggedIn()));
  }

  showForm() => Form(
        key: formKey,
        child: Column(children: <Widget>[
          TextFormField(
            autocorrect: false,
            decoration: InputDecoration(
              labelText: "Email:",
            ),
            validator: (str) =>
                !str.contains('@') ? "Not a Valid Email!" : null,
            onSaved: (str) => _email = str,
          ),
          TextFormField(
            autocorrect: false,
            decoration: InputDecoration(labelText: "Username:"),
            validator: (str) =>
                str.length <= 5 ? "Not a valid username!" : null,
            onSaved: (str) => _username = str,
          ),
          TextFormField(
            autocorrect: false,
            decoration: InputDecoration(labelText: "Password:"),
            validator: (str) =>
                str.length <= 5 ? "Not a valid password!" : null,
            onSaved: (str) => _password = str,
            obscureText: true,
          ),
          RaisedButton(
            child: Text("Submit"),
            onPressed: onPressed,
          )
        ]),
      );

  showPageIfLoggedIn() => Center(
        child: Column(
          children: <Widget>[
            Text("Welcome $_username"),
            RaisedButton(
              child: Text("Logout"),
              onPressed: () {
                setState(() {
                  loggedIn = false;
                });
              },
            )
          ],
        ),
      );

  void onPressed() {
    var form = formKey.currentState;
    //will iterate through all the validator functions
    if (form.validate()) {
      form.save(); //Will iterate through our onSaved functions
      setState(() {
        loggedIn = true;
      });

      var snackbar = SnackBar(
          content: Text("Username: $_username, Email: $_email"),
          duration: Duration(
            microseconds: 500,
          ));

      scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
}
