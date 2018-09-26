import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class VideoFromYoutube extends StatefulWidget {
  VideoFromYoutube({Key key, this.title}) : super(key: key);
  final String title;
  @override
  createState() => VideoState();
}

class VideoState extends State<VideoFromYoutube> {
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

    String deocodedYoutubeLink =
        "https:\/\/r4---sn-p5qlsndz.googlevideo.com\/videoplayback?gir=yes&expire=1537709286&pl=15&clen=49641758&requiressl=yes&fvip=4&ip=54.167.156.229&ei=hkCnW9PCH4PL8gTZvLK4Aw&sparams=clen%2Cdur%2Cei%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cexpire&id=o-AHXCqbqDRc-CXbp5wBQCQguxi0GeDFy6g0Oppt-IiBc5&initcwndbps=5421250&mn=sn-p5qlsndz%2Csn-p5qs7n7s&source=youtube&mm=31%2C29&ratebypass=yes&dur=1034.100&mv=m&mt=1537687612&ms=au%2Crdu&itag=18&key=yt6&mime=video%2Fmp4&ipbits=0&signature=3629ABCCDD904BA84D09CD85924E82D70CF2701A.5B1B0F46BFE1A55265B131DC19066FA3FD405872&lmt=1537174062292887&txp=5531332";
    if (playerController == null) {
      playerController = VideoPlayerController.network(deocodedYoutubeLink)
        ..addListener(listener)
        // ..seekTo(Duration(seconds: 1))
        // ..setLooping(true)
        ..setVolume(
            1.0) //Max  0.0 - 1.0   (it might to work with emulator (the voice output))
        ..initialize();
    } else {
      ///`TODO: Add code for pausing the video`
      if (playerController.value.isPlaying) {
        playerController.pause();
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
            playerController.play();
          },
          child: (playerController == null)
              ? Icon(Icons.pause_circle_filled)
              : (playerController.value.isPlaying)
                  ? Icon(Icons.play_arrow)
                  : Icon(Icons.pause),
        ),
      );
}
