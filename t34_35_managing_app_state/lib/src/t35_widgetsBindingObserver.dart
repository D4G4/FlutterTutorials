import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifecycle',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> with WidgetsBindingObserver {
  AppLifecycleState appLifecycleState;
  List<String> data;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    data = [];
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        setState(() {
          appLifecycleState = state;
          controller.text.isNotEmpty ? data.add(controller.text) : null;
          controller.text = "";
          print(state.toString());
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Orientation And Lifecycle")),
        body: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Center(
              child: Column(children: [
                TextField(
                  controller: controller,
                ),
                Expanded(
                  child: ListView(
                    children: data.map((item) => Text(item)).toList(),
                  ),
                )
              ]),
            );
          },
        ));
  }
}

//Grid

// class HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text("Orientation And Lifecycle")),
//         body: OrientationBuilder(
//           builder: (BuildContext context, Orientation orientation) {
//             return Center(
//               child: GridView.count(
//                 mainAxisSpacing: 10.0,
//                 crossAxisSpacing: 10.0,
//                 crossAxisCount: orientation == Orientation.landscape ? 4 : 2,
//                 children: List.generate(
//                   40,
//                   (int i) => Container(
//                         child: Text("Tile $i"),
//                         color: orientation == Orientation.landscape
//                             ? Colors.lightBlue
//                             : Colors.purple,
//                       ),
//                 ),
//               ),
//             );
//           },
//         ));
//   }
// }
