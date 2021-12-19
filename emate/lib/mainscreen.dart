import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
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
        stream: db.doc("/profile/QDRSrYK1Z5iB09FOCcxV").snapshots(),
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
            List<dynamic> game1 = doc['game1'];
            return Center(
              child: Column(
                children: [
                  Text(
                    doc['username'],
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    doc['language1'],
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    doc['language2'],
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    game1[1].toString(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 40,
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
