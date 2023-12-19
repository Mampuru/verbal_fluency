import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final String recording;
  final int score;

  const ScoreDisplay({super.key,
    required this.recording,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(recording),
      subtitle: Text('Score: $score'),
    );
  }
}