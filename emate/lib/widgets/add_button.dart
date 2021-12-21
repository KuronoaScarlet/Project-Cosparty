import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../profile_screen.dart';

class AddButton extends StatelessWidget {
  final String buttonText;
  final String messageText;
  final List<dynamic> array;
  final String arrayName;

  const AddButton({
    Key? key,
    required this.controller,
    required this.db,
    required this.widget,
    required this.buttonText,
    required this.messageText,
    required this.array,
    required this.arrayName,
  }) : super(key: key);

  final TextEditingController controller;
  final FirebaseFirestore db;
  final ProfileScreen widget;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(messageText),
          actions: [
            TextField(
              controller: controller,
            ),
            ElevatedButton(
              onPressed: () {
                array.add(controller.text);
                db.doc("/users/${widget.userID}").update({arrayName: array});
                if (controller.text.isNotEmpty) {
                  controller.clear();
                }
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
      child: Text(buttonText),
    );
  }
}
