import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class VideoFromStream extends StatefulWidget {
  VideoFromStream({Key key, this.title}) : super(key: key);
  final String title;
  @override
  createState() => VideoState();
}

class VideoState extends State<VideoFromStream> {
  //The plugin will help use to directly interface with platform independent video player
  //And the controller allows us to control how we deal with those particular platform video players
  VideoPlayerController playerController;

  VoidCallback listener;

  void initState() {
    super.initState();

    //We'll attach is void func to our player controller, so when the video receives data from the
    //platform it automatically updates our widget. (with every single frame)
    listener = () {
      setState(() {});
    };
  }

  void createVideo() {
    //To decode the link
    //http://you-link.herokuapp.com/?url=https://www.youtube.com/watch?v=6CdhE3hh2CQ

    //Search for '&c=WEB' and remove it

    //String deocodedYoutubeLink = "https://www.youtube.com/watch?v=kGYUhhq-4hk";
    String deocodedYoutubeLink =
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

    String streamingUrl =
        "https://www.radiantmediaplayer.com/media/bbb-360p.mp4";
    if (playerController == null) {
      playerController = VideoPlayerController.network(streamingUrl)
        ..addListener(listener)
        // ..seekTo(Duration(seconds: 1))
        // ..setLooping(true)
        ..setVolume(
            1.0) //Max  0.0 - 1.0   (it might to work with emulator (the voice output))
        ..initialize();
    } else {
      ///`TODO: Add code for pausing the video`
      if (playerController.value.isPlaying) {
        //playerController.pause();
        //playerController.seekTo(Duration(seconds: 20));
      } else {
        playerController.initialize();
        playerController.play();
      }
    }
  }

//When STATE class is removed from our widget (for whatever reason)
  @override
  void deactivate() {
    playerController.setVolume(0.0);
    playerController.removeListener(listener);
    super.deactivate();
  }

  @override
  build(context) => Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Column(
            children: <Widget>[
              Text("this is some text"),
              AspectRatio(
                aspectRatio:
                    16 / 9, // (1280 / 720)   standart definition -> (4 / 3)
                child: (playerController != null
                    ? VideoPlayer(
                        playerController,
                      )
                    : Container()),
              ),
              Text("this is some text again "),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createVideo();
            if (playerController != null) {
              // if (playerController.value.isPlaying) {
              //   playerController.pause();
              // } else {
              //   playerController.play();
              // }
            } else {
              playerController.play();
            }
          },
          child: (playerController == null)
              ? Icon(Icons.play_arrow)
              : (playerController.value.isPlaying)
                  ? Icon(Icons.pause)
                  : Icon(Icons.play_arrow),
        ),
      );
}
