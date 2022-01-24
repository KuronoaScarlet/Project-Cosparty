import 'package:emate/main_screen.dart';
import 'package:emate/settings_screen.dart';
import 'package:emate/widgets/add_button.dart';
import 'package:emate/widgets/profile_elements.dart';
import 'package:flutter/material.dart';
import 'package:emate/widgets/clickable_icon.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;
  const ProfileScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final db = FirebaseFirestore.instance;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder(
        stream: db.doc("/users/${widget.userID}").snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final doc = snapshot.data!.data();
          if (doc != null) {
            List<dynamic> games = doc['Games'];
            List<dynamic> languages = doc['Languages'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: ListView(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MainScreen(
                                userID: widget.userID,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 35,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const Text(
                        "                       E-Mate",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Profile Screen",
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(
                                userID: widget.userID,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.settings,
                          size: 35,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const ClickableIcon(
                        icon: Icons.person,
                        size: 175,
                        shapeColor: Colors.grey,
                        iconColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            doc["UserName"],
                            style: const TextStyle(fontSize: 30),
                          ),
                          IconButton(
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                    'Change your profile user name!'),
                                actions: <Widget>[
                                  TextField(
                                    controller: controller,
                                    maxLength: 16,
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          db
                                              .doc("/users/${widget.userID}")
                                              .update({
                                            'UserName': controller.text
                                          });
                                          if (controller.text.isNotEmpty) {
                                            controller.clear();
                                          }
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            icon: const Icon(Icons.edit,
                                size: 20, color: Colors.black87),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Languages",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                      ProfileElements(array: languages),
                      AddButton(
                        controller: controller,
                        array: languages,
                        db: db,
                        widget: widget,
                        buttonText: "Add Language",
                        messageText: "Add a new language to your profile",
                        arrayName: "Languages",
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Games",
                        style: TextStyle(fontSize: 20),
                      ),
                      ProfileElements(array: games),
                      AddButton(
                        controller: controller,
                        array: games,
                        db: db,
                        widget: widget,
                        buttonText: "Add Game",
                        messageText: "Add a new game to your profile",
                        arrayName: "Games",
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                "doc id null",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
