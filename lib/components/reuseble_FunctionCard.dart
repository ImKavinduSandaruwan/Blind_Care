import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class FunctionCard extends StatelessWidget {

  late String fileName;
  late String text;
  late VoidCallback onPress;

  FunctionCard(this.fileName, this.text, this.onPress,{super.key});


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xffC5C5C5),
                  width: 1
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xffC5C5C5),
                child: Image(
                  image: AssetImage(fileName),
                ),
              ),
              Text(
                text,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black
                ),
              ),
            ],
          ),
          //height: 100,
        ),
      ),
    );
  }
}