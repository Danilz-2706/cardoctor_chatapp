import 'dart:convert';

import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:cardoctor_chatapp/cardoctor_chatapp.dart';

import 'model/form_text.dart';
import 'model/send_message_request.dart';
import 'model/send_message_response.dart';
import 'navigation_utils.dart';
import 'package:web_socket_channel/io.dart';
import 'package:rive/rive.dart';

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

class _HomePageState extends State<HomePage> {
  late final IOWebSocketChannel channel;
  @override
  void initState() {
    super.initState();

    channel = IOWebSocketChannel.connect(
      Uri.parse(
          'wss://free.blr2.piesocket.com/v3/GR_1694157629801?api_key=yPH1ntAsHtn7CmJohZm3fpw7232PaPAWeyQyasnz&notify_self=1'),
    );
    print('Connect socket');
  }

  Future addMessage(dynamic message) async {
    try {
      channel.sink.add(json.encode(message));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<Map<String, dynamic>> listMessage = [];
    List<Map<String, dynamic>> listMessage = dataSend;

    ChatAppCarDoctorUtilOption data = ChatAppCarDoctorUtilOption(
        apiKey: 'yPH1ntAsHtn7CmJohZm3fpw7232PaPAWeyQyasnz',
        apiSecret: 'YBjSTOa65xpWIWYtpbTkLlhik0IBDDfW',
        cluseterID: 'free.blr2',
        getNotifySelf: '1',
        groupName: 'GR_1694157629801',
        userIDReal: 'Cardoctor1Driver');
    return SafeArea(
      child: ChatDetailScreen(
        appBarCustom: Container(
          width: double.infinity,
          height: 100,
          color: Colors.red,
        ),
        errorGetFile: (p0) {
          if (p0['type'] == 'MAX_SEND_IMAGE_CHAT') {
            setState(() {
              Utils.showToast(
                context,
                p0['text'],
                type: ToastType.ERROR,
              );
            });
          } else if (p0['type'] == 'LIMIT_CHAT_IMAGES_IN_MB') {
            Utils.showToast(
              context,
              p0['text'],
              type: ToastType.ERROR,
            );
          }
        },
        pressCallAudio: () {},
        pressCallVideo: () {},
        pressPickVideo: (p0) {},
        color: Color(0xFF0052FF),
        typingChat: Container(
          height: 28,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: RiveAnimation.asset(
                    'assets/animations/reply-ing.riv',
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ],
          ),
        ),
        typing: (p0) {
          addMessage(p0);
        },
        listHistoryChat: ListMessage(
          senderTextColor: Colors.white,
          senderBackground: Color(0xFF0052FF),
          listMessageLoadMore: [],
          data: data,
          loadMoreHistory: (p0) {
            if (mounted) {
              setState(() {
                listMessage.add(listMessage[2]);
              });
            }
          },
          listMessage: listMessage,
          userInRoomChat: (Map<String, dynamic> value) {},
        ),
        loadMoreHistory: (p0) async {},
        pressPickImage: (p0) async {},
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
        nameTitle: '57bf11111 - Garage Ô Tô Hải Phương',
        data: data,
        press: (value) async {
          await Future.delayed(Duration(seconds: 4));
          addMessage(
            {
              "id": 123,
              "groupId": null,
              "userId": null,
              "profileName": "",
              "originalMessage": "${value['originalMessage']}",
              "filteredMessage": "bng",
              // "attachmentType": "${DateTime.now().millisecondsSinceEpoch}",
              "attachmentType": "${value['attachmentType']}",

              "attachment": null,
              "linkPreview": "",
              "username": 'Cardoctor1Driver',
              "groupName": 'GR_1694157629801',
              "type": null,
              "createdAtStr": DateTime.now().toString(),
              "updatedAtStr": DateTime.now().toString(),
              "createdAt": DateTime.now().toString(),
              "updatedAt": DateTime.now().toString()
            },
          );
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

var i = FormData(
  key: 'form',
  value: [
    FormItem(
      hintText: '',
      label: '',
      text: 'Thông tin yêu cầu',
      type: 'title',
    ),
    FormItem(
      hintText: 'Honda Civic: 82A-57329',
      label: 'Dòng xe',
      text: '',
      type: 'dropdown',
      drop: 'drop',
    ),
    FormItem(
      hintText: 'Honda',
      label: 'Loại xe',
      text: '',
      type: 'dropdown',
      drop: 'drop',
    ),
    FormItem(
        hintText: 'Số km đã chạy',
        label: 'Số km',
        text: '',
        type: 'dropdown',
        drop: 'image',
        value2: ''),
    FormItem(
      hintText: '',
      label: '',
      text: 'controllerDescription.text',
      type: 'textfield',
      // controllerDescription.text == '' || controllerDescription.text.isEmpty
      //     ? 'empty'
      //     : 'textfield',
    ),
  ],
);

var dataSend = [
  {
    "id": 735,
    "groupId": 41,
    "userId": 15,
    "profileName": "Car Doctor Expert",
    "originalMessage":
        "{\"key\":\"form\",\"value\":null,\"valueImage\":null,\"valueFiles\":null,\"valueServices\":[{\"title\":\"Kiểm tra xe và nhận tư vấn tại garage\",\"image\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230908174558929_vidma_recorder_26082023_103014.jpg\"},{\"title\":\"Kiểm tra xe và nhận tư vấn tại gaa xe và nhận tư vấn tại gaa xe và nhận tư vấn tại garage\",\"image\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230908174558929_vidma_recorder_26082023_103014.jpg\"},{\"title\":\"Kiểm tra xe và nhận tư vấn tại garage\",\"image\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230908174558929_vidma_recorder_26082023_103014.jpg\"}]}",
    "filteredMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"Th\u00f4ng tin y\u00eau c\u1ea7u\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"\",\"label\":\"D\u00f2ng xe\",\"hintText\":\"Honda Civic: 82A-57329\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Lo\u1ea1i xe\",\"hintText\":\"Honda\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"S\u1ed1 km\",\"hintText\":\"S\u1ed1 km \u0111\u00e3 ch\u1ea1y\",\"type\":\"dropdown\",\"drop\":\"image\",\"value2\":\"\"},{\"text\":\"controllerDescription.text\",\"label\":\"\",\"hintText\":\"\",\"type\":\"textfield\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "attachmentType": "image",
    "attachment": null,
    "linkPreview": "",
    "username": "Cardoctor1Driver",
    "groupName": "GR_1693357083059",
    "type": 8,
    "createdAtStr": "2023-09-08T17:45:59",
    "updatedAtStr": "2023-09-08T17:45:59",
    "createdAt": "2023-09-08T17:45:59",
    "updatedAt": "2023-09-08T17:45:59"
  },

];
