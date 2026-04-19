import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5A72FF).withValues(alpha: 0.35),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Image(
        image: AssetImage('assets/images/image.png'),
        fit: BoxFit.contain,
      ),
    );
  }
}