import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:flutter/foundation.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import 'package:t19_pathprovider_read_write_data_files/get_permissions.dart'
    as getPermissions;

void main() => runApp(new getPermissions.MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading and Writing to Storage',
      home: Home(
        storage: Storage(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final Storage storage;

  Home({@required this.storage, Key key}) : super(key: key);

  @override
  createState() => HomeState();
}

class HomeState extends State<Home> {
  TextEditingController textController = TextEditingController();
  String state;
  Future<Directory> _appDocDirectory;

  void initState() {
    super.initState();
    widget.storage.readData().then((String value) {
      setState(() {
        state = value;
      });
    });
  }

  Future<File> writeData() async {
    setState(() {
      state = textController.text;
      textController.text = '';
    });

    return widget.storage.writeData(state);
  }

  void getAppDirectory() {
    setState(() {
      _appDocDirectory = pathProvider.getExternalStorageDirectory();
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text("R/W")),
      body: Center(
          child: Column(
        children: <Widget>[
          Text('${state ?? "File is empty"}'),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(controller: textController),
          ),
          RaisedButton(
            child: Text("Write to File"),
            onPressed: writeData,
          ),
          RaisedButton(
            padding: const EdgeInsets.all(10.0),
            child: Text("Get dir path"),
            onPressed: getAppDirectory,
          ),
          FutureBuilder<Directory>(
              future: _appDocDirectory,
              builder: (context, snapshot) {
                Text text = Text('');
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError)
                    text = Text('Error ${snapshot.error}');
                  else if (snapshot.hasData)
                    text = Text('Path: ${snapshot.data.path}');
                  else
                    text = Text('Unavailable');

                  return Container(child: text);
                } else if (snapshot.connectionState == ConnectionState.active) {
                  return CircularProgressIndicator();
                } else
                  return Text('bla');
              })
        ],
      )),
    );
  }
}

// Class that holds all the getters and setters that are required R/W
class Storage {
  Future<String> get docsPath async {
    debugPrint("getting docs path");
    final Directory dir = await pathProvider.getExternalStorageDirectory();
    final String directoryPath = dir.path + '/' + 'dir';
    debugPrint("Directory path will be $directoryPath");
    if (await Directory(directoryPath).exists() == false)
      Directory(directoryPath).create(recursive: true).then((Directory dir) {
        debugPrint('Path of new directory ${dir.path}');
        return dir.path;
      });
    return directoryPath;
  }

  Future<File> get localFile async {
    final path = await docsPath;
    return File('$path/db.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      return body;
    } on FileSystemException {
      writeData("Empty Data");
      return "Empty Data";
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}
