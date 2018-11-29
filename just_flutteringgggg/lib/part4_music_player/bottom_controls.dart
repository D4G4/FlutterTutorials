import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:just_flutteringgggg/part4_music_player/songs.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Material(
          color: accentColor,
          shadowColor: const Color(0x44000000),
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 50.0),
            child: Column(children: <Widget>[
              AudioPlaylistComponent(
                playlistBuilder: (context, playlist, child) {
                  DemoSong song = demoPlaylist.songs[playlist.activeIndex];
                  return RichText(
                    text: TextSpan(
                      text: '' /*Unstyled text */,
                      children: [
                        TextSpan(
                          text: '${song.songTitle}\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: song.artist,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12.0,
                            letterSpacing: 3.0,
                            height: 1.5,
                          ),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      PreviousButton(),
                      PlayPauseButton(),
                      NextButton(),
                    ],
                  ))
            ]),
          )),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioComponent /**Widget that looks up the tree for Audio Widget and it can report the state of Audio Widget */ (
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        IconData icon = Icons.music_note;
        Function onPressed;
        Color buttonColor = lightAccentColor;
        if (player.state == AudioPlayerState.playing) {
          icon = Icons.pause;
          onPressed = player.pause;
          buttonColor = Colors.white;
        } else if (player.state == AudioPlayerState.paused ||
            player.state == AudioPlayerState.completed) {
          icon = Icons.play_arrow;
          onPressed = player.play;
          buttonColor = Colors.white;
        }
        return RawMaterialButton(
          shape: CircleBorder(),
          fillColor: buttonColor,
          splashColor: lightAccentColor,
          highlightColor: lightAccentColor,
          elevation: 20.0,
          highlightElevation: 5.0,
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: darkAccentColor,
              size: 35.0,
            ),
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
      playlistBuilder: (context, Playlist playlist, Widget child) {
        return IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.red,
          icon: Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: playlist.previous,
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
      playlistBuilder: (context, Playlist playlist, child) {
        return IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: playlist.next,
        );
      },
    );
  }
}
