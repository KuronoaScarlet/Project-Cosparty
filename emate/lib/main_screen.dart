import 'package:emate/widgets/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:emate/profile_screen.dart';
import 'package:emate/search_screen.dart';
import 'inbox_screen.dart';

import 'package:emate/widgets/clickable_icon.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  final String userID;
  const MainScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
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
                  const Text(
                    "E-Mate",
                    style: TextStyle(fontSize: 35),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                userID: widget.userID,
                              ),
                            ),
                          );
                        },
                        child: ClickableIcon(
                          icon: Icons.person,
                          size: 90,
                          shapeColor: Colors.grey.shade500,
                          iconColor: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => InboxScreen(
                                userID: widget.userID,
                              ),
                            ),
                          );
                        },
                        child: ClickableIcon(
                          icon: Icons.inbox,
                          size: 90,
                          shapeColor: Colors.grey.shade500,
                          iconColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(
                            userID: widget.userID,
                          ),
                        ),
                      );
                    },
                    child: ClickableIcon(
                      icon: Icons.search_outlined,
                      size: 180,
                      shapeColor: Colors.blue.shade500,
                      iconColor: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      db
                          .doc("/users/${widget.userID}")
                          .update({'connected': !doc['connected']});
                    },
                    child: ClickableIcon(
                      icon: doc['connected']
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye_sharp,
                      size: 80,
                      shapeColor: Colors.white10,
                      iconColor: doc['connected'] ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            );
          } else {
            List<String> games = [];
            List<String> languages = [];
            db
                .doc("/users/${FirebaseAuth.instance.currentUser!.uid}")
                .set({
                  "UserName": "E-Mate#Newuser",
                  "connected": true,
                  "Games": games,
                  "Languages": languages,
                })
                .then((_) {})
                .catchError((_) {});
            return Column(
              children: [
                const Center(
                  child: Text(
                    "doc id null",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AuthGate(),
                      ),
                    );
                  },
                )
              ],
            );
          }
        },
      ),
    );
  }
}
