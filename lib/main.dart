import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HerekamApp());
}

class HerekamApp extends StatelessWidget {
  const HerekamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Herekam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF238636),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}