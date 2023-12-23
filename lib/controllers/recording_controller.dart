import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class RecordingController extends GetxController {
  var isRecording = false.obs;
  var transcript = ''.obs;
  stt.SpeechToText? speech;
  late String path;
  late AudioPlayer audioPlayer;
  var recordings = <String>[].obs; // For storing recordings
  var scores = <int>[].obs; // For storing scores
  late Timer? _timer;
  var timerValue = '60'.obs;

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
    audioPlayer = AudioPlayer();
    initPath();
    fetchRecordings(); // Fetch stored recordings on app start
    fetchScores(); // Fetch stored scores on app start
  }

  void initPath() async {
    final appDir = await getApplicationDocumentsDirectory();
    path = '${appDir.path}/recording.wav';
  }

  //TODO need to fix the recording stops and to soon
  void startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      await speech?.initialize(
        onStatus: (status) {
          if (kDebugMode) {
            print('Speech recognition status: $status');
          }
        },
        onError: (error) {
          if (kDebugMode) {
            print('Error: $error');
          }
        },
      );

      if (speech?.isAvailable ?? false) {
        isRecording.value = true;
        _startTimer();
        await speech?.listen(
          onResult: (result) {
            transcript.value = result.recognizedWords;
          },
          listenFor: const Duration(minutes: 1),
        );
        // stopRecording();
      }
    }
  }

  void stopRecording() async {
    _timer?.cancel();
    await speech?.stop();
    isRecording.value = false;
    timerValue.value = '60';
  }

  //TODO need to fix the play record doesn't work
  Future<void> playRecording(int i) async {
    print("**************************");
    print(path);
    await audioPlayer.play(UrlSource(path));
  }

  void fetchRecordings() async {
    final prefs = await SharedPreferences.getInstance();
    recordings.assignAll(prefs.getStringList('recordings') ?? []);
  }

  void fetchScores() async {
    final prefs = await SharedPreferences.getInstance();
    scores.assignAll(
        prefs.getStringList('scores')?.map((score) => int.tryParse(score) ?? 0).toList() ?? []);
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (timerValue.value == '0') {
          stopRecording();
        } else {
          timerValue.value = (int.parse(timerValue.value) - 1).toString();
        }
      },
    );
  }
}
