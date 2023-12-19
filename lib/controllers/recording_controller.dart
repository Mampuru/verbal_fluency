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
        await speech?.listen(
          onResult: (result) {
            transcript.value = result.recognizedWords;
          },
          listenFor: const Duration(seconds: 60),
        );
        isRecording.value = true;
      }
    }
  }

  void stopRecording() async {
    await speech?.stop();
    isRecording.value = false;
  }

  Future<void> playRecording() async {
    await audioPlayer.play(path as Source);
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
}
