import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cardoctor_chatapp/cardoctor_chatapp.dart';

import 'model/form_text.dart';
import 'model/send_message_request.dart';
import 'navigation_utils.dart';
import 'package:web_socket_channel/io.dart';

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

List<String> list_image = [
  "https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230905132344096_vidma_recorder_04092023_145203.jpg",
  "https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230905132344096_vidma_recorder_04092023_145203.jpg",
  "https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230905132344096_vidma_recorder_04092023_145203.jpg",
  "https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230905132344096_vidma_recorder_04092023_145203.jpg",
  "https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230905132344096_vidma_recorder_04092023_145203.jpg",
  "https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230905132344096_vidma_recorder_04092023_145203.jpg",
  "https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230905132344096_vidma_recorder_04092023_145203.jpg",
  "https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230905132344096_vidma_recorder_04092023_145203.jpg",
];
List<FormFile> list_files = [
  FormFile(
      url:
          'https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230905132344096_vidma_recorder_04092023_145203.jpg',
      path:
          '/data/user/0/com.mfunctions.driver.dev/cache/file_picker//20230905132344096_vidma_recorder_04092023_145203.jpg'),
];
List<Map<String, dynamic>> listMessage = [];

var dataSend = {
  "id": 702,
  "groupId": 33,
  "userId": 2,
  "profileName": "NGUYEN THANH TRUNG",
  "originalMessage": "hh",
  "filteredMessage": "hh",
  "attachmentType": "",
  "attachment": null,
  "linkPreview": "",
  "username": "Cardoctor1Driver",
  "groupName": "GR_1693357083059",
  "type": null,
  "createdAtStr": "2023-09-06T17:23:58",
  "updatedAtStr": "2023-09-06T17:23:58",
  "createdAt": "2023-09-06T17:23:58",
  "updatedAt": "2023-09-06T17:23:58"
};

class _HomePageState extends State<HomePage> {
  late final IOWebSocketChannel channel;
  @override
  void initState() {
    super.initState();

    channel = IOWebSocketChannel.connect(
      Uri.parse(
          'wss://free.blr2.piesocket.com/v3/GR_1693357083059?api_key=5lpozJyOa8smL79mkfrCArzp9i5z3cWYRu4PyjfX&notify_self=1'),
    );
    print('Connect socket');
  }

  Future addMessage(SendMessageRequest message) async {
    try {
      channel.sink.add(json.encode(message));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ChatAppCarDoctorUtilOption data = ChatAppCarDoctorUtilOption(
        apiKey: '5lpozJyOa8smL79mkfrCArzp9i5z3cWYRu4PyjfX',
        apiSecret: 'isXVT8s4Y4AMyeIgGGM2V4WXpfYphzwd',
        cluseterID: 'free.blr2',
        getNotifySelf: '1',
        groupName: 'GR_1693357083059',
        userIDReal: 'Cardoctor1Driver');
    return SafeArea(
      child: ChatDetailScreen(
        historyChat: listMessage,
        loadMoreHistory: (p0) async {},
        pressPickImage: (p0) async {
          if (p0['list'].isNotEmpty) {
            final List<FormImage> list = [];
            for (final e in list_image) {
              list.add(FormImage(image: e));
            }
            final i = FormData(key: 'form', valueImage: list);

            addMessage(
              SendMessageRequest(
                type: 5,
                linkPreview: '',
                groupName: 'GR_1693357083059',
                attachmentType: 'image',
                username: 'Cardoctor1Driver',
                originalMessage: json.encode(i.toMap()),
              ),
            );
          }
        },
        pressPickFiles: (p0) async {
          if (p0['list'].isNotEmpty) {
            final List<FormFile> list = [];
            for (int i = 0; i < p0['list'].length; i++) {
              list.add(
                FormFile(
                  url: list_files[i].url,
                  path: list_files[i].url,
                ),
              );
            }
            final i = FormData(key: 'form', valueFiles: list);
            addMessage(
              SendMessageRequest(
                type: 6,
                linkPreview: '',
                groupName: 'GR_1693357083059',
                attachmentType: 'file',
                username: 'Cardoctor1Driver',
                originalMessage: json.encode(i.toMap()),
              ),
            );
          }
        },
        nameTitle: 'Testing chat',
        data: data,
        press: (value) {
          addMessage(SendMessageRequest.fromJson(value));
        },
        dataRoom: data,
        idSender: 'Cardoctor1Driver',
        pressBack: () {
          NavigationUtils.popToFirst(context);
        },
      ),
    );
  }
}
