import 'package:emate/users_name.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fakeUserID = "oo2FO2sdS0ar0vNq2L53";
    return MaterialApp(
      home: UsersName(
        userID: fakeUserID,
      ),
    );
  }
}
