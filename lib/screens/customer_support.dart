import 'package:alan_voice/alan_voice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// Handles various commands received from the Alan AI dialog script.
  /// Each command triggers a specific action within the app.
  void _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      case "getMsg":
        _textController.text = command["text"];
        sendDataToTheFireStore();
        break;
    }
  }

  /// Asynchronously sends a message to the Firestore database.
  /// This function prepares the message data and adds it to the 'messages' collection in Firestore.
  /// It uses the FirebaseFirestore instance to interact with Firestore.
  void sendDataToTheFireStore() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    // Prepare the data to be stored
    Map<String, dynamic> data = {
      'message': _textController.text,
    };

    await fireStore.collection('messages').add(data)
        .then((value) => print("Message Added"))
        .catchError((error) => print("Failed to add message: $error"));
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Changed to start to avoid overflow
            children: [
              //Container that contains image of the screen
              Container(
                child: Image(
                  width: 300,
                  height: 300,
                  image: AssetImage('images/service.png'),
                ),
              ),
              SizedBox(height: 20), // Add space between widgets

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
              SizedBox(height: 20), // Add space between widgets

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
                onRatingUpdate: (rating) {},
              ),
              SizedBox(height: 20), // Add space between widgets

              //Submit Button
              MaterialButton(
                onPressed:() {
                  sendDataToTheFireStore();
                },
                color: Colors.blue,
                child: Text('Send', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20), // Add space between widgets

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
      ),
    );
  }

}