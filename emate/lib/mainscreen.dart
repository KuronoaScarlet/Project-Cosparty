import 'package:emate/profilescreen.dart';
import 'package:emate/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'inboxscreen.dart';

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
  Widget build(BuildContext context) {
    bool connected = true;
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
                      connected = false;
                    },
                    child: ClickableIcon(
                      icon: Icons.remove_red_eye_sharp,
                      size: 80,
                      shapeColor: Colors.white10,
                      iconColor: connected ? Colors.green : Colors.red,
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

class ClickableIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color shapeColor;
  final Color iconColor;

  const ClickableIcon({
    Key? key,
    required this.icon,
    required this.size,
    required this.shapeColor,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: shapeColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
    );
  }
}
