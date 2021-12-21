import 'package:emate/profile_screen.dart';
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
                                    "Show lenguage",
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
                                    "Show winrate",
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
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Game",
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
