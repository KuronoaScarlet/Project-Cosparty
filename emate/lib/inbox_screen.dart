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
        stream: db.collection("users").snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (BuildContext context, int index) {
                        if (widget.userID !=
                                snapshot.data!.docs.elementAt(index).id &&
                            snapshot.data!.docs.elementAt(index)["connected"] ==
                                true) {
                          return MessageBox(
                              doc: snapshot.data!.docs.elementAt(index));
                        } else {
                          return const SizedBox(
                            height: 0,
                          );
                        }
                      },
                    ),
                  )
                ],
              );
          }
        },
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  final doc;
  const MessageBox({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            const ClickableIcon(
              icon: Icons.person,
              size: 35,
              shapeColor: Colors.grey,
              iconColor: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "${doc["UserName"]} wants to be your friend!",
              style: const TextStyle(fontSize: 13),
            ),
            const Spacer(),
            ClickableIcon(

              icon: Icons.person_add,
              size: 15,
              shapeColor: Colors.grey.shade300,
              iconColor: Colors.black,
            ),
           ClickableIcon(
              icon: Icons.person_remove,
              size: 15,
              shapeColor: Colors.grey.shade300,
              iconColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
