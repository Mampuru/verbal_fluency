import 'package:flutter/material.dart';

import '../controllers/recording_controller.dart';

class RecordingView extends StatelessWidget {
  RecordingView({Key? key}) : super(key: key);
  final RecordingController controller = Get.put(RecordingController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Voice Recorder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Voice Recorder'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                controller.isRecording.value ? 'Recording...' : 'Not Recording',
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
                  controller.playRecording();
                },
                child: const Text('Play Recording'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
