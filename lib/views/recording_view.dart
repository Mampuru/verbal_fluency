import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verbal_fluency/views/result_view.dart';

import '../controllers/recording_controller.dart';

class RecordingView extends StatelessWidget {
  RecordingView({Key? key}) : super(key: key);
  final RecordingController controller = Get.put(RecordingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
              'Time left: ${controller.timerValue.value} seconds',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
            ElevatedButton(
              onPressed: () {
                if (controller.isRecording.value) {
                  controller.stopRecording();
                } else {
                  controller.startRecording();
                }
              },
              child: Obx(
                    () => Text(controller.isRecording.value ? 'Stop Recording' : 'Start Recording'),
              ),
            ),
            Obx(() => Text(controller.transcript.value)),
            ElevatedButton(
              onPressed: () {
                controller.playRecording(0); // Provide an index to play a specific recording
              },
              child: const Text('Play Recording'),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.recordings.length,
                itemBuilder: (context, index) => ScoreDisplay(
                  recording: controller.recordings[index],
                  score: controller.scores[index],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}