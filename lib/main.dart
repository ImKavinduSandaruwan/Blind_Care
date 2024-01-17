import 'package:flutter/material.dart';

void main() {
  runApp(const BlindCareApp());
}

class BlindCareApp extends StatelessWidget {
  const BlindCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}
