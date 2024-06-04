import 'dart:async';
import 'package:audio_test_task/views/play_pause_button.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/phrase.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Phrases? _current;

  final phrasesList = <Phrases>[
    Phrases(words: 'this is one phrase.', time: 1464),
    Phrases(words: 'now the second phrase.', time: 5545),
    Phrases(words: 'end with last phrase.', time: 9672),
    Phrases(words: 'another speaker here.', time: 3322),
    Phrases(words: 'saying her second phrase.', time: 7719),
    Phrases(words: 'and eventually finishing up.', time: 10982),
  ];

  late AudioPlayer audioPlayer;
  late StreamSubscription<Duration> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _setAssets();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  void _setAssets() async {
    audioPlayer = AudioPlayer();
    audioPlayer.setAsset("assets/audios/example_audio.mp3");
    _streamSubscription = audioPlayer.positionStream.listen(_listener);
  }

  void _listener(Duration duration) async {
    var newPhrase = _current;
    final millisecond = duration.inMilliseconds;
    var greater = phrasesList.where((p) => millisecond <= p.time).toList();
    greater.sort((a, b) => a.time.compareTo(b.time));
    newPhrase = greater.first;
    if (newPhrase != _current) {
      _current = newPhrase;
      ///
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Learner"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: phrasesList.length,
            itemBuilder: (context, index) {
              final phrase = phrasesList[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _current == phrase
                      ? const Color(0xff828AE2)
                      : const Color(0xffF2F3FB),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  phrasesList[index].words,
                  style: TextStyle(
                    color: _current == phrase
                        ? Colors.white
                        : const Color(0xff53567A),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          height: 150,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff0E1737),
                Color(0xff828AE2),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                color: const Color(0xff828AE2),
                shape: const OvalBorder(),
                child: SizedBox(
                  height: 66,
                  width: 66,
                  child: Center(
                    child: PlayPauseButton(audioPlayer: audioPlayer),
                  ),
                ),
              ),
              Material(
                color: const Color.fromARGB(88, 182, 182, 182),
                shape: const OvalBorder(),
                child: SizedBox(
                  height: 39,
                  width: 39,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.replay, color: Colors.white),
                      onPressed: () => audioPlayer
                          .seek(Duration.zero), // Seek to the beginning
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
