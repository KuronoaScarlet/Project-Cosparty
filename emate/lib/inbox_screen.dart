import 'package:emate/main_screen.dart';
import 'package:emate/widgets/clickable_icon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InboxScreen extends StatefulWidget {
  final String userID;
  const InboxScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
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
                  const Text(
                    "Inbox Screen",
                    style: TextStyle(fontSize: 20),
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
