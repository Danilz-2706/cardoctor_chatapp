import 'dart:convert';

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
          'wss://free.blr2.piesocket.com/v3/GR_1694157629801?api_key=5lpozJyOa8smL79mkfrCArzp9i5z3cWYRu4PyjfX&notify_self=1'),
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
    List<Map<String, dynamic>> listMessage = dataSend;

    ChatAppCarDoctorUtilOption data = ChatAppCarDoctorUtilOption(
        apiKey: '5lpozJyOa8smL79mkfrCArzp9i5z3cWYRu4PyjfX',
        apiSecret: 'isXVT8s4Y4AMyeIgGGM2V4WXpfYphzwd',
        cluseterID: 'free.blr2',
        getNotifySelf: '1',
        groupName: 'GR_1694157629801',
        userIDReal: 'Cardoctor1Driver');
    return SafeArea(
      child: ChatDetailScreen(
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
          data: data,
          loadMoreHistory: (p0) {
            print('data load more');
            print(listMessage.length);

            setState(() {
              listMessage.add(listMessage[2]);
            });
            print('data load more');
            print(listMessage.length);
          },
          listMessage: listMessage,
        ),
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
        nameTitle:
            'Testing chatTes Testing chatTesTesting chatTesTesting chatTesTesting chatTesTesting chatTes Testing chatTes',
        data: data,
        press: (value) {
          print("123");
          addMessage(dataSend[0]);
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

var dataSend = [
  {
    "id": 736,
    "groupId": 41,
    "userId": 16,
    "profileName": "[TVTĐ] Phạm  Khánh_0965778656",
    "originalMessage": "hjh",
    "filteredMessage": "hjh",
    "attachmentType": "",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor60856DRIVER",
    "groupName": "GR_1694157629801",
    "type": null,
    "createdAtStr": "2023-09-08T17:46:16",
    "updatedAtStr": "2023-09-08T17:46:16",
    "createdAt": "2023-09-08T17:46:16",
    "updatedAt": "2023-09-08T17:46:16"
  },
  {
    "id": 735,
    "groupId": 41,
    "userId": 15,
    "profileName": "Car Doctor Expert",
    "originalMessage":
        "{\"key\":\"form\",\"value\":null,\"valueImage\":[{\"image\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230908174558929_vidma_recorder_26082023_103014.jpg\"}],\"valueFiles\":null}",
    "filteredMessage":
        "{\"key\":\"form\",\"value\":null,\"valueImage\":[{\"image\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230908174558929_vidma_recorder_26082023_103014.jpg\"}],\"valueFiles\":null}",
    "attachmentType": "image",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor1EXPERT",
    "groupName": "GR_1694157629801",
    "type": 5,
    "createdAtStr": "2023-09-08T17:45:59",
    "updatedAtStr": "2023-09-08T17:45:59",
    "createdAt": "2023-09-08T17:45:59",
    "updatedAt": "2023-09-08T17:45:59"
  },
  {
    "id": 734,
    "groupId": 41,
    "userId": 15,
    "profileName": "Car Doctor Expert",
    "originalMessage": "bshsh",
    "filteredMessage": "bshsh",
    "attachmentType": "",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor1EXPERT",
    "groupName": "GR_1694157629801",
    "type": null,
    "createdAtStr": "2023-09-08T17:45:49",
    "updatedAtStr": "2023-09-08T17:45:49",
    "createdAt": "2023-09-08T17:45:49",
    "updatedAt": "2023-09-08T17:45:49"
  },
  {
    "id": 733,
    "groupId": 41,
    "userId": 16,
    "profileName": "[TVTĐ] Phạm  Khánh_0965778656",
    "originalMessage": "bjdjd",
    "filteredMessage": "bjdjd",
    "attachmentType": "",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor60856DRIVER",
    "groupName": "GR_1694157629801",
    "type": null,
    "createdAtStr": "2023-09-08T17:44:44",
    "updatedAtStr": "2023-09-08T17:44:44",
    "createdAt": "2023-09-08T17:44:44",
    "updatedAt": "2023-09-08T17:44:44"
  },
  {
    "id": 732,
    "groupId": 41,
    "userId": 16,
    "profileName": "[TVTĐ] Phạm  Khánh_0965778656",
    "originalMessage": "Tôi cần tư vấn xe báo giá",
    "filteredMessage": "Tôi cần tư vấn xe báo giá",
    "attachmentType": "text",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor60856DRIVER",
    "groupName": "GR_1694157629801",
    "type": null,
    "createdAtStr": "2023-09-08T17:44:29",
    "updatedAtStr": "2023-09-08T17:44:29",
    "createdAt": "2023-09-08T17:44:29",
    "updatedAt": "2023-09-08T17:44:29"
  },
  {
    "id": 731,
    "groupId": 41,
    "userId": 16,
    "profileName": "[TVTĐ] Phạm  Khánh_0965778656",
    "originalMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"Thông tin yêu cầu\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"\",\"label\":\"Loại xe\",\"hintText\":\"Audi A3\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Năm sản xuất\",\"hintText\":\"2020-01-01\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Số km\",\"hintText\":\"Số km đã chạy\",\"type\":\"dropdown\",\"drop\":\"image\",\"value2\":\"6500\"},{\"text\":\"\",\"label\":\"Khu vực\",\"hintText\":\"Mễ Trì Hạ, Phường Mễ Trì, Quận Nam Từ Liêm, Thành phố Hà Nội\",\"type\":\"dropdown\",\"drop\":\"empty\",\"value2\":null},{\"text\":\"NHẬP THÊM MÔ TẢ\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"xnxb\",\"label\":\"\",\"hintText\":\"\",\"type\":\"textfield\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "filteredMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"Thông tin yêu cầu\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"\",\"label\":\"Loại xe\",\"hintText\":\"Audi A3\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Năm sản xuất\",\"hintText\":\"2020-01-01\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Số km\",\"hintText\":\"Số km đã chạy\",\"type\":\"dropdown\",\"drop\":\"image\",\"value2\":\"6500\"},{\"text\":\"\",\"label\":\"Khu vực\",\"hintText\":\"Mễ Trì Hạ, Phường Mễ Trì, Quận Nam Từ Liêm, Thành phố Hà Nội\",\"type\":\"dropdown\",\"drop\":\"empty\",\"value2\":null},{\"text\":\"NHẬP THÊM MÔ TẢ\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"xnxb\",\"label\":\"\",\"hintText\":\"\",\"type\":\"textfield\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "attachmentType": "text",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor60856DRIVER",
    "groupName": "GR_1694157629801",
    "type": 2,
    "createdAtStr": "2023-09-08T17:44:27",
    "updatedAtStr": "2023-09-08T17:44:27",
    "createdAt": "2023-09-08T17:44:27",
    "updatedAt": "2023-09-08T17:44:27"
  },
  {
    "id": 730,
    "groupId": 41,
    "userId": 16,
    "profileName": "[TVTĐ] Phạm  Khánh_0965778656",
    "originalMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"BÁO GIÁ GARAGE\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/CAP5591792750196685025.jpg\",\"label\":\"\",\"hintText\":\"\",\"type\":\"image\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "filteredMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"BÁO GIÁ GARAGE\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/CAP5591792750196685025.jpg\",\"label\":\"\",\"hintText\":\"\",\"type\":\"image\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "attachmentType": "image",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor60856DRIVER",
    "groupName": "GR_1694157629801",
    "type": 2,
    "createdAtStr": "2023-09-08T17:44:26",
    "updatedAtStr": "2023-09-08T17:44:26",
    "createdAt": "2023-09-08T17:44:26",
    "updatedAt": "2023-09-08T17:44:26"
  },
  {
    "id": 729,
    "groupId": 41,
    "userId": 14,
    "profileName": "[TVTĐ] NGUYỄN  THÀNH TRUNG_0901706555",
    "originalMessage": "Tôi cần tư vấn xe báo giá",
    "filteredMessage": "Tôi cần tư vấn xe báo giá",
    "attachmentType": "text",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor1DRIVER",
    "groupName": "GR_1694157629801",
    "type": null,
    "createdAtStr": "2023-09-08T15:51:36",
    "updatedAtStr": "2023-09-08T15:51:36",
    "createdAt": "2023-09-08T15:51:36",
    "updatedAt": "2023-09-08T15:51:36"
  },
  {
    "id": 728,
    "groupId": 41,
    "userId": 14,
    "profileName": "[TVTĐ] NGUYỄN  THÀNH TRUNG_0901706555",
    "originalMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"Thông tin yêu cầu\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"\",\"label\":\"Loại xe\",\"hintText\":\"Audi S5\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Năm sản xuất\",\"hintText\":\"2020-01-01\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Số km\",\"hintText\":\"Số km đã chạy\",\"type\":\"dropdown\",\"drop\":\"image\",\"value2\":\"6500\"},{\"text\":\"\",\"label\":\"Khu vực\",\"hintText\":\"Quận Ba Đình, Thành phố Hà Nội, Việt Nam\",\"type\":\"dropdown\",\"drop\":\"empty\",\"value2\":null},{\"text\":\"NHẬP THÊM MÔ TẢ\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"bzbsbdbdb\",\"label\":\"\",\"hintText\":\"\",\"type\":\"textfield\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "filteredMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"Thông tin yêu cầu\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"\",\"label\":\"Loại xe\",\"hintText\":\"Audi S5\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Năm sản xuất\",\"hintText\":\"2020-01-01\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Số km\",\"hintText\":\"Số km đã chạy\",\"type\":\"dropdown\",\"drop\":\"image\",\"value2\":\"6500\"},{\"text\":\"\",\"label\":\"Khu vực\",\"hintText\":\"Quận Ba Đình, Thành phố Hà Nội, Việt Nam\",\"type\":\"dropdown\",\"drop\":\"empty\",\"value2\":null},{\"text\":\"NHẬP THÊM MÔ TẢ\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"bzbsbdbdb\",\"label\":\"\",\"hintText\":\"\",\"type\":\"textfield\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "attachmentType": "text",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor1DRIVER",
    "groupName": "GR_1694157629801",
    "type": 2,
    "createdAtStr": "2023-09-08T15:51:35",
    "updatedAtStr": "2023-09-08T15:51:35",
    "createdAt": "2023-09-08T15:51:35",
    "updatedAt": "2023-09-08T15:51:35"
  },
  {
    "id": 727,
    "groupId": 41,
    "userId": 14,
    "profileName": "[TVTĐ] NGUYỄN  THÀNH TRUNG_0901706555",
    "originalMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"BÁO GIÁ GARAGE\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230908155132251_vidma_recorder_26082023_103014.jpg\",\"label\":\"\",\"hintText\":\"\",\"type\":\"image\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "filteredMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"BÁO GIÁ GARAGE\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/20230908155132251_vidma_recorder_26082023_103014.jpg\",\"label\":\"\",\"hintText\":\"\",\"type\":\"image\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "attachmentType": "image",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor1DRIVER",
    "groupName": "GR_1694157629801",
    "type": 2,
    "createdAtStr": "2023-09-08T15:51:33",
    "updatedAtStr": "2023-09-08T15:51:33",
    "createdAt": "2023-09-08T15:51:33",
    "updatedAt": "2023-09-08T15:51:33"
  },
  {
    "id": 719,
    "groupId": 41,
    "userId": 16,
    "profileName": "[TVTĐ] Phạm  Khánh_0965778656",
    "originalMessage":
        "{\"key\":\"form\",\"value\":null,\"valueImage\":null,\"valueFiles\":[{\"url\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/a.txt\",\"path\":\"/data/user/0/com.mfunctions.driver.dev/cache/file_picker/a.txt\"}]}",
    "filteredMessage":
        "{\"key\":\"form\",\"value\":null,\"valueImage\":null,\"valueFiles\":[{\"url\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/a.txt\",\"path\":\"/data/user/0/com.mfunctions.driver.dev/cache/file_picker/a.txt\"}]}",
    "attachmentType": "file",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor60856DRIVER",
    "groupName": "GR_1694157629801",
    "type": 6,
    "createdAtStr": "2023-09-08T15:41:09",
    "updatedAtStr": "2023-09-08T15:41:09",
    "createdAt": "2023-09-08T15:41:09",
    "updatedAt": "2023-09-08T15:41:09"
  },
  {
    "id": 717,
    "groupId": 41,
    "userId": 14,
    "profileName": "[TVTĐ] NGUYỄN  THÀNH TRUNG_0901706555",
    "originalMessage": "Tôi cần tư vấn xe báo giá",
    "filteredMessage": "Tôi cần tư vấn xe báo giá",
    "attachmentType": "text",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor1DRIVER",
    "groupName": "GR_1694157629801",
    "type": null,
    "createdAtStr": "2023-09-08T15:27:52",
    "updatedAtStr": "2023-09-08T15:27:52",
    "createdAt": "2023-09-08T15:27:52",
    "updatedAt": "2023-09-08T15:27:52"
  },
  {
    "id": 716,
    "groupId": 41,
    "userId": 14,
    "profileName": "[TVTĐ] NGUYỄN  THÀNH TRUNG_0901706555",
    "originalMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"Thông tin yêu cầu\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"\",\"label\":\"Loại xe\",\"hintText\":\"Audi A1\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Năm sản xuất\",\"hintText\":\"2022-01-01\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Số km\",\"hintText\":\"Số km đã chạy\",\"type\":\"dropdown\",\"drop\":\"image\",\"value2\":\"6500\"},{\"text\":\"\",\"label\":\"Khu vực\",\"hintText\":\"Mễ Trì Hạ, Phường Mễ Trì, Quận Nam Từ Liêm, Thành phố Hà Nội\",\"type\":\"dropdown\",\"drop\":\"empty\",\"value2\":null},{\"text\":\"NHẬP THÊM MÔ TẢ\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"vgg\",\"label\":\"\",\"hintText\":\"\",\"type\":\"textfield\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "filteredMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"Thông tin yêu cầu\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"\",\"label\":\"Loại xe\",\"hintText\":\"Audi A1\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Năm sản xuất\",\"hintText\":\"2022-01-01\",\"type\":\"dropdown\",\"drop\":\"drop\",\"value2\":null},{\"text\":\"\",\"label\":\"Số km\",\"hintText\":\"Số km đã chạy\",\"type\":\"dropdown\",\"drop\":\"image\",\"value2\":\"6500\"},{\"text\":\"\",\"label\":\"Khu vực\",\"hintText\":\"Mễ Trì Hạ, Phường Mễ Trì, Quận Nam Từ Liêm, Thành phố Hà Nội\",\"type\":\"dropdown\",\"drop\":\"empty\",\"value2\":null},{\"text\":\"NHẬP THÊM MÔ TẢ\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"vgg\",\"label\":\"\",\"hintText\":\"\",\"type\":\"textfield\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "attachmentType": "text",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor1DRIVER",
    "groupName": "GR_1694157629801",
    "type": 2,
    "createdAtStr": "2023-09-08T15:27:50",
    "updatedAtStr": "2023-09-08T15:27:50",
    "createdAt": "2023-09-08T15:27:50",
    "updatedAt": "2023-09-08T15:27:50"
  },
  {
    "id": 715,
    "groupId": 41,
    "userId": 14,
    "profileName": "[TVTĐ] NGUYỄN  THÀNH TRUNG_0901706555",
    "originalMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"BÁO GIÁ GARAGE\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/CAP4325173084563498940.jpg\",\"label\":\"\",\"hintText\":\"\",\"type\":\"image\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "filteredMessage":
        "{\"key\":\"form\",\"value\":[{\"text\":\"BÁO GIÁ GARAGE\",\"label\":\"\",\"hintText\":\"\",\"type\":\"title\",\"drop\":null,\"value2\":null},{\"text\":\"https://stg-api.cardoctor.com.vn/chat-service/api/v1/files/2023/09/chat-data/CAP4325173084563498940.jpg\",\"label\":\"\",\"hintText\":\"\",\"type\":\"image\",\"drop\":null,\"value2\":null}],\"valueImage\":null,\"valueFiles\":null}",
    "attachmentType": "image",
    "attachment": null,
    "linkPreview": "",
    "username": "CarDoctor1DRIVER",
    "groupName": "GR_1694157629801",
    "type": 2,
    "createdAtStr": "2023-09-08T15:27:48",
    "updatedAtStr": "2023-09-08T15:27:48",
    "createdAt": "2023-09-08T15:27:48",
    "updatedAt": "2023-09-08T15:27:48"
  }
];
