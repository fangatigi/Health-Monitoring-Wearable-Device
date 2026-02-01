import 'package:flutter/material.dart';
import '../../models/health_data.dart';
import '../ecg_wave.dart';

class EcgPage extends StatelessWidget {
  final HealthData? data;

  const EcgPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text("ECG Monitor"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: data == null
            ? const Text(
                "Waiting for ECG data...",
                style: TextStyle(color: Colors.white70),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: EcgWave(sample: data!.ecg)
                ),
              ),
    );
  }
}
