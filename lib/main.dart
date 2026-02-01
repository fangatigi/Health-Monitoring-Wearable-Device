import 'package:flutter/material.dart';

import 'ui/auth/login_page.dart';
import 'ui/auth/register_page.dart';
import 'app_shell.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: "/login",
      routes: {
        "/login": (_) => const LoginPage(),
        "/register": (_) => const RegisterPage(),
        "/app": (_) => const AppShell(),
      },
    );
  }
}
