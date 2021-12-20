import 'package:emate/main_screen.dart';
import 'package:emate/settings_screen.dart';
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MainScreen(
                                userID: widget.userID,
                              ),
                            ),
                          );
                        },
                        child: const ClickableIcon(
                          icon: Icons.arrow_back,
                          size: 35,
                          shapeColor: Colors.white10,
                          iconColor: Colors.grey,
                        ),
                      ),
                      const Text(
                        "                     E-Mate",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "    Profile Screen",
                        style: TextStyle(fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(
                                userID: widget.userID,
                              ),
                            ),
                          );
                        },
                        child: const ClickableIcon(
                          icon: Icons.settings,
                          size: 35,
                          shapeColor: Colors.white10,
                          iconColor: Colors.grey,
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
                      Text(
                        doc["UserName"],
                        style: const TextStyle(fontSize: 35),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "    Languages",
                            style: TextStyle(fontSize: 20),
                          ),
                          Row(
                            children: const [],
                          )
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "    Games",
                            style: TextStyle(fontSize: 20),
                          ),
                          Row(
                            children: const [],
                          )
                        ],
                      )
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
