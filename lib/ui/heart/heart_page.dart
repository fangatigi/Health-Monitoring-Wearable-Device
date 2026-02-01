import 'package:flutter/material.dart';
import '../../models/health_data.dart';

class HeartPage extends StatelessWidget {
  final HealthData? data;
  const HeartPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: data == null
          ? const Text("Waiting for data...")
          : Text(
              "Heart Rate\n${data!.hr} bpm",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28),
            ),
    );
  }
}
