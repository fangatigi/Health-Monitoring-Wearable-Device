import 'package:flutter/material.dart';
import '../../models/health_data.dart';

class FallPage extends StatelessWidget {
  final HealthData? data;
  const FallPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Center(child: Text("No data yet"));
    }

    return Center(
      child: data!.fall
          ? const Text(
              "⚠ FALL DETECTED",
              style: TextStyle(
                fontSize: 26,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            )
          : const Text(
              "No fall detected",
              style: TextStyle(fontSize: 20),
            ),
    );
  }
}
