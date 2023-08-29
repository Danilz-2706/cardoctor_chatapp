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
    final option = ChatAppCarDoctorUtilOption(
      groupName: '1',
      historyChat: [],
      isGetList: true,
      listRoom: list,
      apiKey: '5lpozJyOa8smL79mkfrCArzp9i5z3cWYRu4PyjfX',
      apiSecret: 'isXVT8s4Y4AMyeIgGGM2V4WXpfYphzwd',
      cluseterID: 'free.blr2',
      getNotifySelf: '1',
    );
    // final sdkUtil = ChatAppCarDoctorUtil(option,null);
    // await sdkUtil.open(context);
    NavigationUtils.rootNavigatePageWithArguments(
      context,
      ChatDetailScreen(
        data: option,
      ),
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
