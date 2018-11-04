///`RichText`
///In absence of color, touch events are not processed

import 'package:flutter/material.dart';
import 'package:flutter_challange_music_plater/theme.dart';
import 'package:flutter_challange_music_plater/songs.dart';
import 'dart:math';
import 'package:flutter_challange_music_plater/bottom_controls.dart';
import 'package:flutter_challange_music_plater/radial_drag_gesture_detector.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Music Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    /// To keep the music playing in background
    /// So it doesn't disappear
    return AudioPlaylist(
      playlist: demoPlaylist.songs.map((DemoSong song) {
        return song.audioUrl;
      }).toList(growable: false),
      playbackState: PlaybackState.paused,
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: const Color(0xFFDDDDDD),
            onPressed: () {},
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              color: const Color(0xFFDDDDDD),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
//---------------Seek bar-----------------------------
            Expanded(
              child: AudioPlaylistComponent(
                playlistBuilder: (context, playlist, child) {
                  String albumArtUrl =
                      demoPlaylist.songs[playlist.activeIndex].albumArtUrl;
                  return new AudioRadialSeekBar(albumArtUrl: albumArtUrl);
                },
              ),
            ),
//---------------Visualizer---------------------------
            Container(
              width: double.infinity,
              height: 125.0,
              child: Container(),
            ),
//---------Song title, artist name and controls-------
            new BottomControls()
          ],
        ),
      ),
    );
  }
}

class AudioRadialSeekBar extends StatefulWidget {
  final String albumArtUrl;
  const AudioRadialSeekBar({
    this.albumArtUrl,
    Key key,
  }) : super(key: key);

  @override
  AudioRadialSeekBarState createState() {
    return new AudioRadialSeekBarState();
  }
}

class AudioRadialSeekBarState extends State<AudioRadialSeekBar> {
  double _seekPercent;
  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayhead,
        WatchableAudioProperties.audioSeeking,
      ],
      playerBuilder: (context, AudioPlayer player, Widget child) {
        double playbackProgress = 0.0;
        //Loading or buffering or liveStream
        if (null != player.audioLength && null != player.position) {
          //position is acually a duration
          playbackProgress = player.position.inMilliseconds /
              player.audioLength.inMilliseconds;
        }

        //_seekPercent = player.isSeeking ? _seekPercent : 0.0;

        return RadialSeekBar(
          seekPercent: playbackProgress,
          progress: playbackProgress,
          onSeekRequested: (double seekPercent) {
            print('Received seekPercetn $seekPercent');
            setState(() => _seekPercent = seekPercent);
            final seekMillis =
                (player.audioLength.inMilliseconds * seekPercent).round();
            player.seek(Duration(milliseconds: seekMillis));
          },
          child: Container(
            color: accentColor,
            child: Image.network(
              widget.albumArtUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class RadialSeekBar extends StatefulWidget {
  final double seekPercent;
  final double progress;
  final Widget child;
  final Function(double) onSeekRequested;
  const RadialSeekBar({
    this.seekPercent = 0.0,
    this.progress = 0.0,
    this.child,
    this.onSeekRequested,
    Key key,
  }) : super(key: key);

  @override
  RadialSeekBarState createState() {
    return new RadialSeekBarState();
  }
}

class RadialSeekBarState extends State<RadialSeekBar> {
  /// What is the purpose of have _startDragPercent when we have seek parcent??
  /// When music is playing, it will constantly be updaing seekParcentage,
  /// and when user drags, we don't want any kind of miscalculation b/w the values
  /// coz we'll get multiple values when user will be dragging.
  double _progress = 0.0;

  PolarCoord _startDragCoord;
  double _startDragPercent;
  double _currentDragPercent;

  void initState() {
    super.initState();
    print('init state');
    _progress = widget.progress;
  }

  /// If we are not currently dragging but we receive the changed value as music is playing
  /// the progress and the thumb will automatically
  /// but `if we are dragging`, then we are only listning to _currentDragPercent
  /// so event if seekPercent is changed "automatically" (beneath us), we will only be
  /// listening to the change in the value being done by _currentDragPercent
  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('did update widget');
    _progress = widget.seekPercent;
  }

  _onDragStart(PolarCoord startCoord) {
    _startDragCoord = startCoord;
    _startDragPercent = _progress;
  }

  _onDragUpdate(PolarCoord updatedCoord) {
    final dragAngle = updatedCoord.angle - _startDragCoord.angle;
    final dragPercent =
        dragAngle / (2 * pi); //Divided by number of radiants in the circle

    setState(
        () => _currentDragPercent = ((_startDragPercent + dragPercent) % 1.0));
  }

  onDragEnd() {
    if (widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }
    setState(() {
      _currentDragPercent = null;
      _startDragCoord = null;
      _startDragPercent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double thumbPosition = _progress;
    if (_currentDragPercent != null) {
      thumbPosition = _currentDragPercent;
    } else if (widget.seekPercent != null) {
      thumbPosition = widget.seekPercent;
    }
    return RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: onDragEnd,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors
            .transparent, //In absence of color, touch events are not processed
        child: Center(
          child: Container(
            width: 140.0,
            height: 140.0,
            child: RadialProgressBar(
              progressPercent: thumbPosition,
              progressColor: accentColor,
              thumbPosition: thumbPosition,
              thumbColor: lightAccentColor,
              trackColor: const Color(0xFFDDDDDD),
              innerPadding: const EdgeInsets.all(10.0),
              outerPadding: const EdgeInsets.all(10.0),
              child: ClipOval(clipper: CircleClipper(), child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  @override
  bool shouldReclip(CustomClipper<Rect> oldDelegate) {
    return true;
  }

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: min(size.width, size.height) / 2);
  }
}

class RadialProgressBar extends StatefulWidget {
  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;
  final Widget child;

  RadialProgressBar({
    this.trackWidth = 3.0,
    this.trackColor = Colors.grey,
    this.progressWidth = 5.0,
    this.progressColor = Colors.black,
    this.progressPercent = 0.1,
    this.thumbSize = 10.0,
    this.thumbColor = Colors.black,
    this.thumbPosition = 0.1,
    this.outerPadding = const EdgeInsets.all(0.0),
    this.innerPadding = const EdgeInsets.all(0.0),
    this.child,
  });

  _RadialProgressBarState createState() => _RadialProgressBarState();
}

class _RadialProgressBarState extends State<RadialProgressBar> {
  EdgeInsets _insetsForPainter() {
    /// Make room for the painted track, progress, and thumb.
    /// We divide by 2.0 :: we want to allow flush painting against the track,
    /// so we only need to `account the thickness outside the track`, not inside.
    final outerThickness = max(
          widget.trackWidth,
          max(widget.progressWidth, widget.thumbSize),
        ) /
        2.0; //so we'll let the seekbar overlap the child by half

    return EdgeInsets.all(outerThickness);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: widget.outerPadding,
        child: CustomPaint(
          foregroundPainter: RadialSeekBarPainter(
            trackWidth: widget.trackWidth,
            trackColor: widget.trackColor,
            progressWidth: widget.progressWidth,
            progressColor: widget.progressColor,
            progressPercent: widget.progressPercent,
            thumbColor: widget.thumbColor,
            thumbPosition: widget.thumbPosition,
            thumbSize: widget.thumbSize,
          ),
          child: Padding(
            padding: _insetsForPainter() + widget.innerPadding,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Try [InheritedWidget] for props maybe?
class RadialSeekBarPainter extends CustomPainter {
  final double trackWidth;
  final Color trackColor;
  final Paint trackPaint;

  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final Paint progressPaint;

  final double thumbSize;
  final double thumbPosition;
  final Paint thumbPaint;
  final Color thumbColor;

  RadialSeekBarPainter({
    @required this.trackWidth,
    @required this.trackColor,
    @required this.progressWidth,
    @required this.progressColor,
    @required this.progressPercent,
    @required this.thumbSize,
    @required this.thumbPosition,
    @required this.thumbColor,
  })  : trackPaint = Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = trackWidth,
        progressPaint = Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = progressWidth
          ..strokeCap = StrokeCap.round,
        thumbPaint = Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    //Accounting thickest width
    final outerThickness = max(trackWidth, max(progressWidth, thumbSize));

    Size constrainedSize = Size(
      size.width - outerThickness,
      size.height - outerThickness,
    );

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(constrainedSize.width, constrainedSize.height) / 2;

    // Paint track
    canvas.drawCircle(
      center,
      radius,
      trackPaint,
    );

    // Paint progress
    final progressAngle = 2 * pi * progressPercent;
    final startAngle = -pi / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius), //boundries
      startAngle, // 0 is right    //Start from
      progressAngle, // how many degress is there a sweep (from up(top) to right, it's not 0 but pi/2 coz we sweeped pi/2 radians to reach there)
      false, //Connect to center?
      progressPaint,
    );

    // Paint thumb
    final thumbAngle =
        2 * pi * thumbPosition - (pi / 2); //Not sweep angle but absolute angle
    //final thumbAngle = (startAngle) * thumbPosition;
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = Offset(thumbX, thumbY) + center;
    final double thumbRadius = thumbSize / 2.0;

    canvas.drawCircle(
      thumbCenter,
      thumbRadius,
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }
}
