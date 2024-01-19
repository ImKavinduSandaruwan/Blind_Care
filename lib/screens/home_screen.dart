import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:projectblindcare/constants/constant.dart';
import 'package:projectblindcare/screens/reuseble_FunctionCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.keyboard_voice_rounded)
        ],
        color: mainThemeColor,
        backgroundColor: Colors.white,
        height: 60,
      ),
      body: Container(
        child: Column(
          children: [
            /// This expand widget contains image, text and stuff
            Expanded(
              child: Container(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
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
                    SafeArea(
                      child: Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome Back',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 30,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    Text(
                                      'Set Your Destination',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 20,
                                          letterSpacing: 4
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.sunny,size: 30,)
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Image(
                                width: screenWidth,
                                image: const Svg('images/blind.svg'),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /// This expand widget contains function buttons
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          FunctionCard("images/map.svg","Blind Map"),
                          FunctionCard("images/transport.svg","Transport"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          FunctionCard("images/emergency.svg","Emergency"),
                          FunctionCard("images/service.svg","Help Center"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}