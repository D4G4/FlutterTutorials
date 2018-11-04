import 'package:flutter/material.dart';
import 'package:flutter_challange_music_plater/theme.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:flutter_challange_music_plater/songs.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: accentColor,
      child: Material(
        //shadowColor: const Color(0x44000000),
        color: accentColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 50.0),
          child: Column(
            children: <Widget>[
              AudioPlaylistComponent(
                playlistBuilder: (_, playlist, child) {
                  DemoSong demoSong = demoPlaylist.songs[playlist.activeIndex];
                  return RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(),
                      children: [
                        TextSpan(
                            text: '${demoSong.songTitle.toUpperCase()}\n',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4.0,
                              height: 1.5,
                            )),
                        TextSpan(
                          text: demoSong.artist,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12.0,
                            letterSpacing: 3.0,
                            height: 1.5,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new PreviousButton(),
                    new PlayPauseButton(),
                    new NextButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Looks up for an AudioWidget and can report the state of AudioWidget
    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        IconData icon = Icons.music_note;
        Color buttonColor = lightAccentColor;
        Function onPressed;

        switch (player.state) {
          case AudioPlayerState.playing:
            icon = Icons.pause;
            onPressed = player.pause;
            buttonColor = Colors.white;
            break;
          case AudioPlayerState.paused:
          case AudioPlayerState.completed:
            icon = Icons.play_arrow;
            onPressed = player.play;
            buttonColor = Colors.white;
            break;
          default:
        }
        return RawMaterialButton(
          shape: CircleBorder(),
          fillColor: buttonColor,
          splashColor: lightAccentColor,
          highlightColor: lightAccentColor.withOpacity(0.5),
          elevation: 10.0,
          highlightElevation: 5.0,
          onPressed: onPressed,
          child: Icon(
            icon,
            color: darkAccentColor,
            size: 40.0,
          ),
        );
      },
    );
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.skip_previous,
            size: 35.0,
          ),
          onPressed: playlist.previous,
          color: Colors.white,
        );
      },
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.skip_next,
            size: 35.0,
          ),
          onPressed: playlist.next,
          color: Colors.white,
        );
      },
    );
  }
}
