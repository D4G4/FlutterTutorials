import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part4_music_player/colors.dart';
import 'package:just_flutteringgggg/part4_music_player/songs.dart';
import 'package:just_flutteringgggg/part4_music_player/bottom_controls.dart';
import 'package:just_flutteringgggg/helper/radial_drag_gesture_detector.dart';

import 'package:fluttery_audio/fluttery_audio.dart';

import 'dart:math';

const DEGREES_360 = pi * 2;

class MusicPlayer extends StatefulWidget {
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylist(
      // audioUrl: demoPlaylist.songs[1].audioUrl,
      playlist: demoPlaylist.songs.map((DemoSong song) {
        return song.audioUrl;
      }).toList(),
      playbackState: PlaybackState.playing,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {},
            color: const Color(0xFFDDDDDD),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
              color: const Color(0xFFDDDDDD),
            ),
          ],
          title: Text(''),
        ),
        body: Column(children: <Widget>[
          /** Seekbar*/
          Expanded(
            child: AudioPlaylistComponent(
              playlistBuilder: (context, Playlist playlist, child) {
                String albumArtUrl =
                    demoPlaylist.songs[playlist.activeIndex].albumArtUrl;
                return new AudioRadialSeekBar(
                  albumArtUrl: albumArtUrl,
                );
              },
            ),
          ),

          /** Visualizer*/
          Container(
            width: double.infinity,
            height: 125.0,
          ),

          /** Song title, artist name and controls*/
          BottomControls()
        ]),
      ),
    );
  }
}

class AudioRadialSeekBar extends StatefulWidget {
  final String albumArtUrl;
  const AudioRadialSeekBar({Key key, this.albumArtUrl}) : super(key: key);

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
        /** Start rotating animation on buffering */
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        double playbackProgress = 0.0;
        if (player.audioLength != null && player.position != null
            /**When buffering, when you don't know the size of media, or liveStream(but it doesn't make much sense) */) {
          playbackProgress = player.position.inMilliseconds /
              player.audioLength.inMilliseconds;
        }

        _seekPercent = player.isSeeking ? _seekPercent : null;
        return RadialSeekBar(
          progress: playbackProgress,
          seekPercent: _seekPercent,
          onSeekRequested: (double seekPercentage) {
            _seekPercent = seekPercentage;
            final seekMilliSeconds =
                player.audioLength.inMilliseconds * seekPercentage;
            Duration seekDuration =
                Duration(milliseconds: seekMilliSeconds.round());
            player.seek(seekDuration);
            setState(() {});
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
  final Function(double) onSeekRequested; //When user lets go of dragging
  RadialSeekBar({
    this.seekPercent,
    this.progress,
    this.onSeekRequested,
    this.child,
  });
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {
  double _progress = 0.0;
  PolarCoord _startDragCoord;
  double _startDragPecentage;
  double _currentDragPercent;

  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    /**
     * When we are not dragging, the seekPercent will change automatically
     * But if we are dragging then we are only listening to currentDragPercent
     * and even though widget.seekPercent is changing beneath us, we won't be listening to it. 
     * But now we will.
     */
    super.didUpdateWidget(oldWidget);
    _progress = widget.progress;
  }

  void _onRadialDragStart(PolarCoord polarCoord) {
    _startDragCoord = polarCoord;
    _startDragPecentage = _progress;
  }

  void _onRadialDragUpdate(PolarCoord polarCoord) {
    var difference = polarCoord.angle - _startDragCoord.angle;
    _currentDragPercent =
        ((difference / DEGREES_360) + _startDragPecentage) % 1;
    setState(() {});

    //print(currentDragPercent);
  }

  void _onRadialDragEnd() {
    if (widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }
    _startDragCoord = null;
    _startDragPecentage = null;
    _currentDragPercent = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double thumbPosition =
        _currentDragPercent ?? (widget.seekPercent ?? _progress);
    return Container(
      child: RadialDragGestureDetector(
        onRadialDragStart: _onRadialDragStart,
        onRadialDragUpdate: _onRadialDragUpdate,
        onRadialDragEnd: _onRadialDragEnd,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors
              .transparent /** In absence of color, touch events are not processed */,
          child: Center(
            child: Container(
              width: 150.0,
              height: 150.0,
              child: RadialProgressBar(
                progressColor: accentColor,
                trackColor: const Color(0xFFDDDDDD),
                thumbColor: lightAccentColor,
                progressPercentage: thumbPosition,
                thumbPosition: thumbPosition,
                innerPadding: 10.0,
                child: ClipOval(
                  clipper: CircleClipper(),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  @override
  bool shouldReclip(CustomClipper oldDelegate) {
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
  final Widget child;

  final double progressPercentage;
  final double progressWidth;
  final Color progressColor;

  final double thumbPosition;
  final double thumbSize;
  final Color thumbColor;

  final double trackWidth;
  final Color trackColor;

  final double innerPadding;
  final double outerPadding;

  RadialProgressBar({
    this.child,
    this.progressColor = Colors.black,
    this.progressPercentage = 0.0,
    this.progressWidth = 5.0,
    this.thumbColor = Colors.black,
    this.thumbPosition = 0.0,
    this.thumbSize = 10.0,
    this.trackColor = Colors.grey,
    this.trackWidth = 3.0,
    this.innerPadding = 0.0,
    this.outerPadding = 0.0,
  });
  _RadialProgressBarState createState() => _RadialProgressBarState();
}

class _RadialProgressBarState extends State<RadialProgressBar> {
  double _insetsForPainter() {
    final outerThickness = max(
        widget.trackWidth,
        max(widget.progressWidth, widget.thumbSize) /
            2 /** We want to let seekbar overlap the child by half */);
    return outerThickness;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.outerPadding),
      child: Container(
        child: CustomPaint(
          foregroundPainter: RadialSeekBarPainter(
            progressColor: widget.progressColor,
            progressPercentage: widget.progressPercentage,
            progressWidth: widget.progressWidth,
            thumbColor: widget.thumbColor,
            thumbPosition: widget.thumbPosition,
            thumbSize: widget.thumbSize,
            trackColor: widget.trackColor,
            trackWidth: widget.trackWidth,
          ),
          child: Padding(
            padding: EdgeInsets.all(_insetsForPainter() + widget.innerPadding),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class RadialSeekBarPainter extends CustomPainter {
  final double progressPercentage;
  final double progressWidth;
  final Paint progressPaint;

  final double thumbPosition;
  final double thumbSize;
  final Paint thumbPaint;

  final double trackWidth;
  final Paint trackPaint;

  RadialSeekBarPainter({
    @required progressColor,
    @required this.progressPercentage,
    @required this.progressWidth,
    @required thumbColor,
    @required this.thumbPosition,
    @required this.thumbSize,
    @required trackColor,
    @required this.trackWidth,
  })  : trackPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = trackColor
          ..strokeWidth = trackWidth,
        thumbPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = thumbColor,
        progressPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = progressColor
          ..strokeWidth = progressWidth;

  @override
  bool shouldRepaint(RadialSeekBarPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final outerThickness = max(trackWidth, max(progressWidth, thumbSize));
    Size constrainedSize =
        Size(size.width - outerThickness, size.height - outerThickness);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(constrainedSize.width, constrainedSize.height) / 2;

    // Track
    canvas.drawCircle(center, radius, trackPaint);

    // DrawProgress
    double startAngle = -pi / 2;
    double sweepAngle = DEGREES_360 * progressPercentage;
    canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        startAngle,
        sweepAngle,
        false,
        progressPaint);

    // Thumb
    final thumbAngle = (DEGREES_360 * thumbPosition) + startAngle;
    final x = cos(thumbAngle) * radius;
    final y = sin(thumbAngle) * radius;
    final Offset thumbCenter = Offset(x, y) + center;
    final thumbRadius = thumbSize / 2;
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }
}
