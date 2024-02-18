import 'package:flutter/material.dart';
import 'package:projectblindcare/constants/constant.dart';

class SquareTile extends StatelessWidget {

  final String imagePath;
  final Function()? onTap;

  const SquareTile({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(color: mainThemeColor),
            borderRadius: BorderRadius.circular(10),
            color: fadedRoundColors
        ),
        child: Image.asset(imagePath,height: 52,),
      ),
    );
  }
}
