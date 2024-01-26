import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectblindcare/screens/splash_screen.dart';

void main() {
  ///Make application portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const BlindCareApp());
}

class BlindCareApp extends StatelessWidget {
  const BlindCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
