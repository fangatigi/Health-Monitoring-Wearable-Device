import 'package:flutter/material.dart';
import '../../models/patient_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PatientProfile profile = PatientProfile.defaultProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text("Profile & Settings"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Patient Information"),
            _infoTile("Name", profile.name),
            _infoTile("Age", profile.age.toString()),
            _infoTile("Gender", profile.gender),

            const SizedBox(height: 24),

            _sectionTitle("Health Thresholds"),

            _sliderTile(
              label: "Min Heart Rate",
              value: profile.hrMin.toDouble(),
              min: 30,
              max: 80,
              onChanged: (v) => setState(() => profile.hrMin = v.toInt()),
            ),

            _sliderTile(
              label: "Max Heart Rate",
              value: profile.hrMax.toDouble(),
              min: 90,
              max: 180,
              onChanged: (v) => setState(() => profile.hrMax = v.toInt()),
            ),

            _sliderTile(
              label: "Min SpO₂ (%)",
              value: profile.spo2Min.toDouble(),
              min: 85,
              max: 100,
              onChanged: (v) => setState(() => profile.spo2Min = v.toInt()),
            ),

            _sliderTile(
              label: "Max Temperature (°C)",
              value: profile.tempMax,
              min: 36,
              max: 40,
              onChanged: (v) => setState(() => profile.tempMax = v),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _sliderTile({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ${value.toStringAsFixed(1)}",
          style: const TextStyle(color: Colors.white),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: Colors.cyanAccent,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
