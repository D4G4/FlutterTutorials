///What is Dependency Injection??
///

import 'package:flutter/material.dart';
import 'package:t42_dependency_injection/injector.dart';
import 'package:t42_dependency_injection/model.dart';

import 'package:http/http.dart';

void main() {
  Injector.configure(RepoType.MOCK);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dependy Injection',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> {
  Injector injector;

  @override
  void initState() {
    super.initState();
    injector = Injector();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("DI and Isolate Demo")),
        body: FutureBuilder<List<Photo>>(
          future: injector.photoRepo.fetchPhotos(Client()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return snapshot.hasData
                  ? PhotoGrid(photos: snapshot.data)
                  : Center(
                      child: Text("No text"),
                    );
            } else if (snapshot.connectionState == ConnectionState.active) {
              return CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("waiting..."));
            } else {
              return Center(child: Text("Idle"));
            }
          },
        ));
  }
}

class PhotoGrid extends StatelessWidget {
  final List<Photo> photos;

  PhotoGrid({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Checking photos status");
    if (photos != null) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0),
        itemCount: photos.length,
        itemBuilder: (context, index) => Image.network(photos[index].url),
        // itemBuilder: (context, index) => Text('Hello ${photos[index].title}'),
      );
    }
    print("Null");
    return Center(child: Text("Nil"));
  }
}
