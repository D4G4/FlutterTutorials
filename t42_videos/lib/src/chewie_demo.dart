import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieDemo extends StatefulWidget {
  final String title;

  ChewieDemo({this.title = 'Chewie Demo'});

  createState() => ChewieState();
}

class ChewieState extends State<ChewieDemo> {
  TargetPlatform _platform;

  VideoPlayerController _controller;

  void initState() {
    super.initState();
    // _controller = VideoPlayerController.network(
    //   'https://github.com/flutter/assets-for-api-docs/blob/master/assets/videos/butterfly.mp4?raw=true',
    // );
    // _controller = VideoPlayerController.network(
    //   'https:\/\/r4---sn-p5qs7n7s.googlevideo.com\/videoplayback?key=yt6&expire=1538003907&c=WEB&lmt=1537210330673487&txp=5531332&mt=1537981332&ratebypass=yes&mime=video%2Fmp4&requiressl=yes&fvip=4&beids=9466586&id=o-AGtm6WCiFdA0czbG9vmBHRrZuOqKigvylEBVIPfCXZFe&sparams=dur%2Cei%2Cid%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cexpire&itag=22&ms=au%2Conr&source=youtube&mv=u&dur=1034.100&signature=B137999511E41836586F5159D7907E73938B4863.9C2993F463A5380331A5F3DD08648798696C835F&pl=22&ipbits=0&mm=31%2C26&mn=sn-p5qs7n7s%2Csn-vgqsrne6&ei=Y7-rW5KeIsz68gTWiqvwCQ&ip=54.196.108.242',
    // );
    _controller = VideoPlayerController.network(
      'https://www.youtube.com/watch?v=aAL6IUX5cek',
    );
  }

  @override
  build(context) => Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Chewie(
                  _controller,
                  aspectRatio: 3 / 2,
                  autoPlay: true,
                  looping: true,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _controller = new VideoPlayerController.network(
                          'https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4',
                        );
                      });
                    },
                    child: Padding(
                      child: Text("Video 1"),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
                new Expanded(
                  child: new FlatButton(
                    onPressed: () {
                      setState(() {
                        String deocodedYoutubeLink =
                            "https:\/\/r4---sn-p5qlsndz.googlevideo.com\/videoplayback?gir=yes&expire=1537709286&pl=15&clen=49641758&requiressl=yes&fvip=4&ip=54.167.156.229&ei=hkCnW9PCH4PL8gTZvLK4Aw&sparams=clen%2Cdur%2Cei%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cexpire&id=o-AHXCqbqDRc-CXbp5wBQCQguxi0GeDFy6g0Oppt-IiBc5&initcwndbps=5421250&mn=sn-p5qlsndz%2Csn-p5qs7n7s&source=youtube&mm=31%2C29&ratebypass=yes&dur=1034.100&mv=m&mt=1537687612&ms=au%2Crdu&itag=18&key=yt6&mime=video%2Fmp4&ipbits=0&signature=3629ABCCDD904BA84D09CD85924E82D70CF2701A.5B1B0F46BFE1A55265B131DC19066FA3FD405872&lmt=1537174062292887&txp=5531332";
                        // _controller = new VideoPlayerController.network(
                        //   'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4',
                        // );
                        _controller = new VideoPlayerController.network(
                          deocodedYoutubeLink,
                        );
                      });
                    },
                    child: new Padding(
                      padding: new EdgeInsets.symmetric(vertical: 16.0),
                      child: new Text("Video 2"),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.android;
                      });
                    },
                    child: Padding(
                        child: Text("Android Controls"),
                        padding: EdgeInsets.symmetric(vertical: 16.0)),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.iOS;
                      });
                    },
                    child: Padding(
                        child: Text("iOS Controls"),
                        padding: EdgeInsets.symmetric(vertical: 16.0)),
                  ),
                )
              ],
            )
          ],
        ),
      );
}
