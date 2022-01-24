import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SearchElements extends StatelessWidget {
  final List array;
  const SearchElements({Key? key, required this.array}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fs = firebase_storage.FirebaseStorage.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (array.length <= 3)
            for (var i = 0; i < array.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
                          width: 45,
                        );
                      },
                    ),
                  ],
                ),
              ),
          if (array.length > 3)
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: FutureBuilder(
                  future: fs.ref("${array[i]}.png").getDownloadURL(),
                  builder: (context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return Image.network(
                      snapshot.data!,
                      width: 45,
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
