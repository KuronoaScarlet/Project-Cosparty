import 'package:emate/main_screen.dart';
import 'package:emate/widgets/clickable_icon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersName extends StatefulWidget {
  final String userID;
  const UsersName({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  _UsersName createState() => _UsersName();
}

class _UsersName extends State<UsersName> {
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
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "E-Mate",
                        style: TextStyle(fontSize: 50),
                      ),
                    ],
                  ),
                 TextField(
              controller: controller,
            ),
            ElevatedButton(
              child: const Text("login (fake)"),
              onPressed: () {
                /*db.collection("/users").add({
                    "UserName":controller.text, //your data which will be added to the collection and collection will be created after this
                    "connected":true, //your data which will be added to the collection and collection will be created after this
                    }).then((_){
                      print("collection created");
                    }).catchError((_){
                      print("an error occured");
                    });*/
                   db
                      .doc("/users/${widget.userID}")
                      .update({'UserName': controller.text});
                  String fakeUserID = "oo2FO2sdS0ar0vNq2L53";
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => MainScreen(userID: fakeUserID),
                  ),
                );
              },
            )
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