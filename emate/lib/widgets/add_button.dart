import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../profile_screen.dart';

class AddButton extends StatefulWidget {
  final String buttonText;
  final String messageText;
  final List<dynamic> array;
  final String arrayName;
  final bool changer;

  const AddButton({
    Key? key,
    required this.db,
    required this.widget,
    required this.buttonText,
    required this.messageText,
    required this.array,
    required this.arrayName,
    required this.changer,
  }) : super(key: key);

  final FirebaseFirestore db;
  final ProfileScreen widget;

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  late TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController(text: "");
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> l = [
      "Spanish",
      "English",
      "Chinese",
      "French",
      "German",
      "Japanese",
      "Italian",
      "Korean",
      "Russian",
      "Portuguese"
    ];
    List<String> g = [
      "Apex Legends",
      "Battle Cats",
      "Clash Royale",
      "Clash of Clans",
      "Epic Seven",
      "Fortnite",
      "Genshin Impact",
      "Heartstone",
      "League of Legends",
      "Minecraft",
      "Osu!",
      "Pubg",
      "Rust",
      "Smash Bros",
      "Valorant"
    ];
    String temp = "";

    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(widget.messageText),
                actions: <Widget>[
                  DropdownButton(
                    items: (widget.changer)
                        ? l
                            .map((e) =>
                                DropdownMenuItem(child: Text(e), value: e))
                            .toList()
                        : g
                            .map((e) =>
                                DropdownMenuItem(child: Text(e), value: e))
                            .toList(),
                    onChanged: (value) {
                      setState(
                        () {
                          temp = value.toString();
                        },
                      );
                    },
                    hint: Text(temp),
                    isDense: true,
                    isExpanded: true,
                    itemHeight: null,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.array.add(temp);
                      widget.db
                          .doc("/users/${widget.widget.userID}")
                          .update({widget.arrayName: widget.array});
                      if (controller.text.isNotEmpty) {
                        controller.clear();
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
      ),
      child: Text(widget.buttonText),
    );
  }
}


/**/