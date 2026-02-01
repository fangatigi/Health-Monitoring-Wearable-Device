import 'package:flutter/material.dart';
import '../models/health_data.dart';
import 'ecg_wave.dart';
import 'health_ring.dart';

class Dashboard extends StatelessWidget {
  final HealthData? data;
  final bool connected;

  const Dashboard({
    super.key,
    required this.data,
    required this.connected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== CONNECTION STATUS (RESTORED) =====
          Text(
            connected ? "CONNECTED" : "DISCONNECTED",
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: connected ? Colors.greenAccent : Colors.redAccent,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Live Health Metrics",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 32),

          // ===== HEART & SPO2 =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HealthRing(
                label: "Heart Rate",
                value: data?.hr.toDouble() ?? 0,
                maxValue: 200,
                unit: "bpm",
                color: Colors.redAccent,
              ),
              HealthRing(
                label: "SpO₂",
                value: data?.spo2.toDouble() ?? 0,
                maxValue: 100,
                unit: "%",
                color: Colors.lightBlueAccent,
              ),
            ],
          ),

          const SizedBox(height: 36),

          // ===== TEMPERATURE (RESTORED) =====
          Center(
            child: _metricCard(
              "Body Temperature",
              data != null ? data!.temp.toStringAsFixed(1) : "--",
              "°C",
            ),
          ),

          const SizedBox(height: 36),

          // ===== ECG PREVIEW =====
          const Text(
            "ECG Signal",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(14),
            ),
            child: data == null
                ? const SizedBox(
                    height: 120,
                    child: Center(
                      child: Text(
                        "Waiting for ECG data...",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                : EcgWave(sample: data!.ecg)
                  ),

          const SizedBox(height: 28),

          // ===== FALL ALERT =====
          if (data?.fall == true)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF7F1D1D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "⚠ FALL DETECTED",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
     ),
    );
  }

  Widget _metricCard(String title, String value, String unit) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
