import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileElements extends StatelessWidget {
  final List array;
  const ProfileElements({Key? key, required this.array}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fs = firebase_storage.FirebaseStorage.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (var i = 0; i < array.length; i++)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: fs.ref("${array[i]}.png").getDownloadURL(),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          return Image.network(
                            snapshot.data!,
                            width: 40,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        array[i].toString(),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
