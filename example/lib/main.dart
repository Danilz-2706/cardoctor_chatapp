import 'package:flutter/material.dart';
import 'package:cardoctor_chatapp/cardoctor_chatapp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const ChatListScreen(
        apiKey: 'apiKey',
        apiSecret: 'apiSecret',
        cluseterID: 'cluseterID',
        user1Id: '',
        user2Id: '',
        getNotifySelf: 1,
        getPresence: 1,
        jwt: '',
      ),
    );
  }
}
