import 'package:flutter/material.dart';
import 'welcome/welcome_page.dart'; // thay vì welcome_page.dart

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(), // thay thế WelcomePage bằng WelcomeView
    );
  }
}
