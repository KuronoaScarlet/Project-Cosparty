import 'package:flutter/material.dart';

import 'package:emate/profile_screen.dart';
import 'package:emate/search_screen.dart';
import 'inbox_screen.dart';

import 'package:emate/widgets/clickable_icon.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
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
  late bool a;
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: db.doc("/user1/GdZ30bm3hotRFyDU7GSZ").snapshots(),
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
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
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
                              builder: (context) => const InboxScreen(),
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
                          builder: (context) => const SearchScreen(),
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
                      if (doc['connected'] == true) {
                        db
                            .doc("/user1/GdZ30bm3hotRFyDU7GSZ")
                            .update({'connected': false});
                      }
                      if (doc['connected'] == false) {
                        db
                            .doc("/user1/GdZ30bm3hotRFyDU7GSZ")
                            .update({'connected': true});
                      }
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
