import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final processingState = snapshot.data?.processingState;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return const CircularProgressIndicator();
        } else if (audioPlayer.playing) {
          return IconButton(
            icon: const Icon(
              Icons.pause,
              color: Colors.white,
              size: 35,
            ),
            onPressed: audioPlayer.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 35,
            ),
            onPressed: audioPlayer.play,
          );
        }
      },
    );
  }
}
