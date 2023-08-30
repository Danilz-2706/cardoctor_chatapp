import 'package:flutter/material.dart';
import 'package:cardoctor_chatapp/cardoctor_chatapp.dart';

import 'navigation_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

var list = [
  {
    "avatar": "assets/imgs/ic_check.png",
    "name": "Gara Tuan Hung",
    "last_message": "Like your...",
    "time": "13:25",
    "read": true,
  },
  {
    "avatar": "assets/imgs/ic_check.png",
    "name": "Gara Tuan Hung",
    "last_message": "Like your...",
    "time": "13:25",
    "read": true,
  },
  {
    "avatar": "assets/imgs/ic_check.png",
    "name": "Gara Tuan Hung",
    "last_message": "Like your...",
    "time": "13:25",
    "read": false,
  },
  {
    "avatar": "assets/imgs/ic_check.png",
    "name": "Gara Tuan Hung",
    "last_message": "Like your...",
    "time": "13:25",
    "read": false,
  }
];

class _HomePageState extends State<HomePage> {
  String id = '123';
  Future openListRoomUtils() async {
    ChatAppCarDoctorUtilOption data = ChatAppCarDoctorUtilOption(
        apiKey: '7T3DbecohNyHTtYbLg3gFiw0TtcsCayLfft7eeLM',
        apiSecret: 'isXVT8s4Y4AMyeIgGGM2V4WXpfYphzwd',
        cluseterID: 'free.blr2',
        getNotifySelf: '1',
        groupName: 'GR_1693357083059',
        historyChat: []);
    return ChatDetailScreen(
      data: data,
      // stackWidget: ButtonWidget(title: 'Đặt lịch', onPressed: () {}),
      press: (value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    print(id);

    return Container(
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            openListRoomUtils();
          },
          child: Text(
            'ahihi',
          ),
        ),
      ),
    );
  }
}
