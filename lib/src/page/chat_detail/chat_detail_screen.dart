import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

import '../../model/send_message_request.dart';
import '../../model/send_message_response.dart';
import '../../widget/receiver_card.dart';
import '../../widget/sender_card.dart';
import '../chat_list/chat_list_screen.dart';
import '../contains.dart';

class ChatDetailScreen extends StatefulWidget {
  final String avatar;
  final String name;
  final String cluseterID;
  final String apiKey;
  final String apiSecret;
  final String user1Id;
  final String user2Id;
  final int getNotifySelf;
  final int getPresence;
  final String jwt;
  final PreferredSize? appBar;

  const ChatDetailScreen({
    Key? key,
    required this.avatar,
    required this.name,
    required this.cluseterID,
    required this.apiKey,
    required this.apiSecret,
    required this.user1Id,
    required this.user2Id,
    required this.getNotifySelf,
    required this.getPresence,
    required this.jwt,
    this.appBar,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late final IOWebSocketChannel channel;
  late ScrollController scrollController;
  late String? _privateChannelName;
  late String? _url;
  late String? _urlWithNoti;
  late String? _urlWithAuth;
  final List<SendMessageResponse> listMessage = [];

  final String idUserFrom = "CarDoctor348GARAGE_OWNER";
  void scrollListToEnd() async {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  late TextEditingController controller;

  List<File> filesList = [];
  Future getImage() async {
    filesList.clear();
    ImagePicker imagePicker = ImagePicker();
    final List<XFile> imageFile =
        await imagePicker.pickMultiImage().catchError((e) {});
    if (imageFile.isNotEmpty) {
      for (var e in imageFile) {
        filesList.add(File(e.path));
      }
    } else {}
  }

  Future getFile() async {
    filesList.clear();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['xls', 'pdf', 'doc'],
    );

    if (result != null) {
      filesList = result.paths.map((path) => File(path!)).toList();
    } else {
      print("not choose file");
    }
  }

  Future doWithIcon() async {}
  Future doWithFormReviewQuotes() async {}

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => scrollListToEnd());
    controller = TextEditingController();
    _privateChannelName = 'private_chat_${widget.user1Id}_${widget.user2Id}';
    _url =
        'wss://${widget.cluseterID}.piesocket.com/v3/1?api_key=${widget.cluseterID}';
    _urlWithNoti = '$_url&notify_self=${widget.getNotifySelf}';
    _urlWithAuth = '$_url&jwt=${widget.jwt}';

    channel = IOWebSocketChannel.connect(
      Uri.parse(
          'wss://free.blr2.piesocket.com/v3/1?api_key=5lpozJyOa8smL79mkfrCArzp9i5z3cWYRu4PyjfX&notify_self=1'),
    );
    connectWebsocket();
  }

  @override
  void dispose() {
    channel.sink.close();
    controller.dispose();
    super.dispose();
  }

  connectWebsocket() {
    try {
      channel.stream.asBroadcastStream().listen(
            (message) {
              print(message);
              setState(() {
                listMessage.insert(
                    0, SendMessageResponse.fromJson(json.decode(message)));
              });
            },
            cancelOnError: true,
            onError: (error) {
              if (kDebugMode) {
                print(error);
              }
            },
            onDone: () {},
          );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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
    return Scaffold(
      appBar: widget.appBar,
      backgroundColor: kBgColors,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: listMessage.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            "Gui tin nhan den chuyen gia cua chung toi de nhan tu van nhe!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kTextGreyDarkColors,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        itemCount: listMessage.length,
                        // controller: scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index > 0 &&
                              listMessage[index].username == idUserFrom &&
                              listMessage[index - 1].username == idUserFrom) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SenderCard(
                                data: listMessage[index],
                              ),
                            );
                          }
                          if (listMessage[index].username == idUserFrom) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: SenderCard(
                                data: listMessage[index],
                              ),
                            );
                          }
                          if (index > 0 &&
                              listMessage[index].username != idUserFrom &&
                              listMessage[index - 1].username != idUserFrom) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: ReceiverCard(
                                onlyOnePerson: true,
                                data: listMessage[index],
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: ReceiverCard(
                              onlyOnePerson: false,
                              data: listMessage[index],
                            ),
                          );
                        },
                      ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              color: Colors.white,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await getImage();
                      print(filesList);
                      //
                      var message = SendMessageRequest(
                        originalMessage: '',
                        attachmentType: TypeSend.images.name,
                        linkPreview:
                            "http://localhost:6666/chat-service/api/v1/files/2023/08/others/santafe.jpeg",
                        username: idUserFrom,
                        groupName: '',
                      );
                      addMessage(message);
                    },
                    child: Image.asset(
                      'assets/imgs/ic_gallary.png',
                      package: Consts.packageName,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await getFile();
                      print(filesList);
                    },
                    child: Image.asset(
                      'assets/imgs/ic_link.png',
                      package: Consts.packageName,
                    ),
                  ),
                  Container(
                    width: 204,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Color.fromRGBO(246, 246, 246, 1),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                        } else {}
                      },
                      controller: controller,
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Nhập nội dung chat",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 0,
                          bottom: 0,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller.text != '') {
                        var message = SendMessageRequest(
                          originalMessage: controller.text,
                          attachmentType: TypeSend.images.name,
                          linkPreview:
                              "http://localhost:6666/chat-service/api/v1/files/2023/08/others/santafe.jpeg",
                          username: idUserFrom,
                          groupName: '',
                        );
                        addMessage(message);

                        setState(() {
                          controller.text = '';
                        });
                      }
                    },
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: Image.asset(
                        'assets/imgs/ic_button_send.png',
                        package: Consts.packageName,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum TypeSend { text, images, files }
