import 'package:emate/main_screen.dart';
import 'package:emate/widgets/clickable_icon.dart';
import 'package:emate/widgets/search_elements.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  final String userID;
  const SearchScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
                        return UserBox(
                            doc: snapshot.data!.docs.elementAt(index));
                      } else {
                        return const SizedBox(
                          height: 0,
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class UserBox extends StatelessWidget {
  final doc;
  const UserBox({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> games = doc['Games'];
    List<dynamic> languages = doc['Languages'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        "${doc["UserName"]}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [SearchElements(array: languages)],
                  ),
                  Row(
                    children: const [
                      StateIcons(
                        selectedIcon: Icon(
                          Icons.favorite,
                          size: 20,
                        ),
                      ),
                      StateIcons(
                        selectedIcon: Icon(
                          Icons.person_add,
                          size: 20,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                height: 125,
                width: 1,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
              ),
              Column(
                children: [
                  const Text("Games:"),
                  Row(
                    children: [SearchElements(array: games)],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StateIcons extends StatelessWidget {
  final selectedIcon;
  const StateIcons({
    Key? key,
    required this.selectedIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: selectedIcon,
    );
  }
}
