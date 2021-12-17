import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class mainscreen extends StatefulWidget {
  const mainscreen({
    Key? key,
  }) : super(key: key);

  @override
  State<mainscreen> createState() => _mainscreen();
}

class _mainscreen extends State<mainscreen> {
  String? username;
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
          stream: db.doc("/test/QGzrvOClb2GssLjfGStI").snapshots(),
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
                  child: Text(
                doc['text'],
                style: TextStyle(color: Colors.red),
              ));
            } else {
              return const Center(
                  child:
                      Text("doc id null", style: TextStyle(color: Colors.red)));
            }
          }),
    );
  }
}
