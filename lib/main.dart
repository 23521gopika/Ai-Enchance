import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AiPhotoEnhancerApp());
}

class AiPhotoEnhancerApp extends StatelessWidget {
  const AiPhotoEnhancerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}