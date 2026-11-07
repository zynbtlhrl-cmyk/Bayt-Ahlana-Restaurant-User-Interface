import 'package:bayt_ahlana_estaurant/Screen/Home/Widget.dart';
import 'package:bayt_ahlana_estaurant/screens/Login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'بيت أهلنا',
      theme: ThemeData(
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF765237)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
