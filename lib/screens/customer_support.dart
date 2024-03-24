import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:projectblindcare/constants/constant.dart';

import '../components/auth_service.dart';
import '../components/square_tile.dart';

class CustomerService extends StatefulWidget {
  const CustomerService({super.key});

  @override
  State<CustomerService> createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {

  final TextEditingController _textController = TextEditingController();

  ///Implementing alan AI
  _CustomerServiceState() {
    AlanVoice.addButton("72c64715b451423bf6ac4a0ab4e8c0ba2e956eca572e1d8b807a3e2338fdd0dc/stage");
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch(command["command"]) {
      case "getMsg":
        break;
  }


  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.arrow_back_sharp),
                SizedBox(width: 10,),
                Text("Customer Support"),
              ],
            ),
            Icon(Icons.support_agent_sharp)
          ],
        ),
        backgroundColor: mainThemeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Container that contains image of the screen
            Container(
              child: Image(
                width: 300,
                height: 300,
                image: AssetImage('images/service.png'),
              ),
            ),

            //Text field for getting user inputs
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Send Feedback',
                border: OutlineInputBorder(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _textController.clear(); // Correctly using a function here
                  },
                  child: Icon(Icons.clear),
                ),
              ),
            ),

            //Rating bar
            RatingBar.builder(
              initialRating: 3.5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {

              },
            ),

            //Submit Button
            MaterialButton(
              onPressed:() {},
              color: Colors.blue,
              child: Text('Send', style: TextStyle(color: Colors.white)),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //google button
                SquareTile(
                    imagePath:'images/google.png',
                    onTap: AuthService().signInWithGoogle
                ),

                SizedBox(width: 10,),

                //Apple button
                SquareTile(
                    imagePath: 'images/apple.png',
                    onTap: AuthService().signInWithApple
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}