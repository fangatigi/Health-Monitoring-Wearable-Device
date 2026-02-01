import 'package:flutter/material.dart';
import 'ble/ble_service.dart';
import 'models/health_data.dart';

import 'ui/dashboard.dart';
import 'ui/heart/heart_page.dart';
import 'ui/ecg/ecg_page.dart';
import 'ui/fall/fall_page.dart';
import 'ui/profile/profile_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final BleService ble = BleService();

  HealthData? latest;
  bool connected = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    ble.init();
    ble.dataStream.listen((d) {
      setState(() {
        latest = d;
        connected = true;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final pages = [
  Dashboard(data: latest, connected: connected),
  HeartPage(data: latest),
  EcgPage(data: latest),
  FallPage(data: latest),
  const ProfilePage(), 
];


    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        backgroundColor: const Color(0xFF020617),
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Heart"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "ECG"),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Alerts"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
