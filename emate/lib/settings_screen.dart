import 'package:emate/profile_screen.dart';
import 'package:emate/widgets/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emate/widgets/clickable_icon.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  final String userID;
  const SettingsScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final db = FirebaseFirestore.instance;
  late TextEditingController controller;
  bool isCheckedLeng = false;
  bool isCheckedWinrate = false;
  bool isCheckedPreferences = false;

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
            List<dynamic> games = doc['Games'];
            List<dynamic> languages = doc['Languages'];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        child: const ClickableIcon(
                          icon: Icons.arrow_back,
                          size: 32,
                          shapeColor: Colors.white10,
                          iconColor: Colors.grey,
                        ),
                      ),
                      const Text(
                        "E-Mate",
                        style: TextStyle(fontSize: 20),
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
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              "Settings\n",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Show languages",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Switch(
                                      value: isCheckedLeng,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckedLeng = value!;
                                        });
                                      }),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Show WinRate",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Switch(
                                      value: isCheckedWinrate,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckedWinrate = value!;
                                        });
                                      }),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Show other Game Preferences \non search\n",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Switch(
                                      value: isCheckedPreferences,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isCheckedPreferences = value!;
                                        });
                                      }),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Languages",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Column(
                                  children: [
                                    for (var j = 0; j < languages.length; j++)
                                      Row(
                                        children: [
                                          Text(languages[j].toString()),
                                          IconButton(
                                            onPressed: () => showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  PopUp(
                                                array: languages,
                                                iter: j,
                                                db: db,
                                                widget: widget,
                                                nameArray: "Languages",
                                              ),
                                            ),
                                            icon: const Icon(Icons.delete,
                                                size: 20,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Games",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Column(
                                  children: [
                                    for (var i = 0; i < games.length; i++)
                                      Row(
                                        children: [
                                          Text(games[i].toString()),
                                          IconButton(
                                            onPressed: () => showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  PopUp(
                                                array: games,
                                                iter: i,
                                                db: db,
                                                widget: widget,
                                                nameArray: "Games",
                                              ),
                                            ),
                                            icon: const Icon(Icons.delete,
                                                size: 20,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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

class PopUp extends StatelessWidget {
  const PopUp({
    Key? key,
    required this.array,
    required this.iter,
    required this.db,
    required this.widget,
    required this.nameArray,
  }) : super(key: key);

  final List array;
  final int iter;
  final FirebaseFirestore db;
  final SettingsScreen widget;
  final String nameArray;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete ${array[iter]} from your profile?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            array.removeAt(iter);
            db.doc("/users/${widget.userID}").update({nameArray: array});
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
