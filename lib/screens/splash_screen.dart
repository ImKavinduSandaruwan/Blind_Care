import 'package:flutter/material.dart';
import '../constants/constant.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    navigateToMainWindow();
  }

  /// Asynchronously navigates to the main window of the application after a specified splash duration.
  /// This function introduces a delay equal to the splashDurationTime before navigating to the HomeScreen.
  /// It uses Navigator.pushReplacement to replace the current route with the HomeScreen, ensuring
  /// that the user cannot navigate back to the splash screen.
  Future<void> navigateToMainWindow() async {
    await Future.delayed(const Duration(milliseconds: splashDurationTime));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }


  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF2FEFE),
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("images/applogo.jpeg"),
                width: 200,
                height: 200,
              ),
              SizedBox(
                height: 90,
              ),
              Center(
                child: Text(
                  'Blind Care',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Empowering Independence, Navigating Life',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: -screenHeight * 0.08,
            right: screenWidth * 0.69,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: fadedRoundColors,
              ),
            ),
          ),
          Positioned(
            top: -screenWidth * 0.29,
            right: screenWidth * 0.49,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: fadedRoundColors,
              ),
            ),
          ),
        ],
      ),
    );
  }
}