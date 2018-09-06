import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example',
      theme: ThemeData.light(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  createState() => HomeState();
}

const String ERROR_MESSAGE = "Kaya chutiyapa hai?";

class HomeState extends State<Home> {
  FirebaseApp firebaseApp;
  final String name = 'flutteraltimedatabase';
  final FirebaseOptions options = const FirebaseOptions(
    googleAppID: '1:261111017240:android:2dac574f358b2dcf',
    apiKey: "AIzaSyAOnqaOetJxqDbjQ-Fli6IQp7K-m2cagOA",
    databaseURL: 'https://flutterealtimedatabase.firebaseio.com',
  );

  Future<Null> _configure() async {
    firebaseApp = await FirebaseApp.configure(name: name, options: options);
    assert(firebaseApp != null);
    print('Configured $firebaseApp');
  }

  List<Item> items = List();
  Item item;
  DatabaseReference databaseReference;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _configure();
    item = Item("", "");
    final FirebaseDatabase database = FirebaseDatabase(app: firebaseApp);

    databaseReference = database.reference().child('items');

    ///when we do not need firebase core
    //itemRef = FirebaseDatabase.instance.reference().child('items');

    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  void _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  void _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();
      databaseReference.push().set(item.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FB example")),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Center(
                child: Form(
                    key: formKey,
                    child: Flex(direction: Axis.vertical, children: <Widget>[
                      ListTile(
                          leading: Icon(Icons.info),
                          title: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Title",
                                counterText: "Counter text",
                                counterStyle: TextStyle(fontSize: 10.0)),
                            initialValue: "",
                            maxLength: 20,
                            onSaved: (val) => item.title = val,
                            validator: (val) =>
                                val == '' ? ERROR_MESSAGE : null,
                          )),
                      ListTile(
                          leading: Icon(Icons.info),
                          title: TextFormField(
                            initialValue: '',
                            maxLength: 20,
                            onSaved: (val) => item.body = val,
                            validator: (val) =>
                                val == '' ? ERROR_MESSAGE : null,
                          )),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: handleSubmit,
                      )
                    ]))),
          ),
          Flexible(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Item itemObj = Item.fromSnapshot(
                    snapshot); //Redundant because we are already listning to the change above
                return new ListTile(
                  //Use snapshot and see what happens..
                  leading: Icon(Icons.message),
                  title: Text(itemObj.title),
                  subtitle: Text(items[index].body),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class Item {
  String key;
  String title;
  String body;

  Item(this.title, this.body);

//Firebase sends data in the form of DataSnapshots
  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value['title'],
        body = snapshot.value['body'];

  toJson() {
    return {"title": title, "body": body};
  }
}

///`What have I learnt ?`
///
/// How to configure `FirebaseApp`
///    Initialize the app in initState()
///    Setup `FirebaseOptions` and then call the await method ->
///    `FirebaseApp.configure()` and pass your options into it
///
/// Then you get `FirebaseDatabase` from your `FirebaseApp` obj as
///      FirebaseDatabase(app: firebaseApp);
///
/// Now you get the databaseReference from it via
///     `databaseObj.reference().child('Name of the table')`
///
/// Attach listeners to your `FirebaseDatabase` object
///
/// Create a `FirebaseAnimatedList`, pass your `FirebaseDatabase` obj to `query`
///
///
/// Also, adding `maxLines` to `TextField` adds a counter to it
///
/// Validation of TextField is done in `Form` and
/// passing `null` in the validate method will mark it as validated
