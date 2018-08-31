import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_scale_boundary.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery Demo',
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: Bleh(),
    );
  }
}

class Bleh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool makeItFullScreen = false;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        color: Colors.red,
        child: GestureDetector(
            onTap: () {
              makeItFullScreen
                  ? SystemChrome.setEnabledSystemUIOverlays([])
                  : SystemChrome.setEnabledSystemUIOverlays(
                      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
              makeItFullScreen = !makeItFullScreen;
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: FlutterLogo(),
                ),
              ],
            )),
      ),
    );
  }
}

class DisplayPhoto extends StatelessWidget {
  final List<String> images = [
    'assets/wallpaper1.jpeg',
    'assets/wallpaper2.jpg',
    'assets/wallpaper3.png',
    'assets/wallpaper4.png',
  ];

  @override
  Widget build(BuildContext context) {
    bool makeItFullScreen = false;
    // TODO: implement build
    return Scaffold(
      body: Center(
          child: GestureDetector(
              onTap: () {
                if (makeItFullScreen != true) {}
                makeItFullScreen
                    ? SystemChrome.setEnabledSystemUIOverlays([])
                    : SystemChrome.setEnabledSystemUIOverlays(
                        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
                makeItFullScreen = !makeItFullScreen;
              },
              child: PhotoView(
                imageProvider: AssetImage(images[1]),
                maxScale: 4.0,
                minScale: PhotoViewScaleBoundary.contained * 0.8,
              ))),
    );
  }
}

class DisplayPage extends StatefulWidget {
  createState() => DisplayPageState();
}

class DisplayPageState extends State<DisplayPage> {
  bool isFullScreen = false;

  final List<String> images = [
    'assets/wallpaper1.jpeg',
    'assets/wallpaper2.jpg',
    'assets/wallpaper3.png',
    'assets/wallpaper4.png',
  ];

//Change viewPortFraction on doubleTap and reset it back on scroll
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(title: Text("Gallery")),
      body: Center(
        child: PageView.builder(
          itemCount: images.length,
          controller: PageController(viewportFraction: 1.0),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  isFullScreen
                      ? SystemChrome.setEnabledSystemUIOverlays([])
                      : SystemChrome.setEnabledSystemUIOverlays(
                          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                  setState(() {
                    isFullScreen = !isFullScreen;
                  });
                },
                child: PhotoView(
                  imageProvider: AssetImage(images[index]),
                  maxScale: 2.0,
                  minScale: PhotoViewScaleBoundary.contained * 0.8,
                ));

            // new Padding(
            //   padding: EdgeInsets.symmetric(
            //     vertical: 16.0,
            //     horizontal: 8.0,
            //   ),
            //   child:

            // Material(
            //     color: Colors.black,
            //     elevation: 5.0,
            //     borderRadius: BorderRadius.circular(8.0),
            //     child: ConstrainedBox(
            //         constraints:
            //             BoxConstraints(maxHeight: 550.0, maxWidth: 50.0),
            //         child: PhotoView(
            //           size: Size.fromWidth(350.0),
            //           imageProvider: AssetImage(images[index]),
            //           maxScale: 2.0,
            //           minScale: PhotoViewScaleBoundary.contained * 0.8,
            //         )));
            //);
          },
        ),
      ),
    );
  }

  // Widget myStack() => Stack(
  //                 fit: StackFit
  //                     .expand, //Determines how a non position widget fits inside your stack widget
  //                 children: [
  //                   // Image.asset(
  //                   //   images[index],
  //                   //   fit: BoxFit.contain,
  //                   // ),
  //                   Positioned(
  //                       width: MediaQuery.of(context).size.width,
  //                       height: MediaQuery.of(context).size.width,
  //                       child: PhotoView(
  //                         imageProvider: AssetImage(images[index]),
  //                         maxScale: 4.0,
  //                         minScale: PhotoViewScaleBoundary.contained * 0.8,
  //                       )),
  //                   // DecoratedBox(
  //                   //   decoration: BoxDecoration(
  //                   //     gradient: LinearGradient(
  //                   //       begin: FractionalOffset.bottomCenter,
  //                   //       end: FractionalOffset.topCenter,
  //                   //       colors: [
  //                   //         Color(0x00000000).withOpacity(0.9),
  //                   //         Color(0xff000000).withOpacity(0.01),
  //                   //       ],
  //                   //     ),
  //                   //   ),
  //                   // )
  //                 ],
  //               );
}
