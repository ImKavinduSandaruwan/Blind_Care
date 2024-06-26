import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectblindcare/screens/emergency_screen.dart';
import 'package:projectblindcare/screens/emergency_settings_screen.dart';
import 'package:projectblindcare/screens/poi.dart';
import 'package:projectblindcare/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  ///Firebase Initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ///Make application portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  List<Map<String, dynamic>> contacts = await EmergencyCantactListHandler.fetchDataFromFirestore();
  contacts.forEach((contact) {
    EmergencyCantactListHandler.addDynamicWidget('${contact['name']}', '${contact['phone']}');
    EmergencySettingsScreenState.addedSavedContact('${contact['name']}','${contact['phone']}');
    EmergencyCantactListHandler.contactsMap[contact['name']] = contact['phone'];
  });

  runApp(const BlindCareApp());
}

class BlindCareApp extends StatelessWidget {
  const BlindCareApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
