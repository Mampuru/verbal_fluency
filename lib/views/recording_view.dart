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
        title: const Text(
          'Voice Recorder',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
              'Time left: ${controller.timerValue.value} seconds',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Change the text color
              ),
            )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controller.isRecording.value) {
                  controller.stopRecording();
                } else {
                  controller.startRecording();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Change the button color
              ),
              child: Obx(
                    () => Text(
                  controller.isRecording.value ? 'Stop Recording' : 'Start Recording',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Change the text color
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
              controller.transcript.value,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.grey, // Change the text color
              ),
            )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.playRecording(0); // Provide an index to play a specific recording
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Change the button color
              ),
              child: const Text(
                'Play Recording',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change the text color
                ),
              ),
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
