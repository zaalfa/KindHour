import 'package:flutter/material.dart';

void main() {
  runApp(const KindHourApp());
}

class KindHourApp extends StatelessWidget {
  const KindHourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KindHourScreen(),
    );
  }
}

class KindHourScreen extends StatelessWidget {
  const KindHourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Good morning! You\'ve got this! ☀️',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
