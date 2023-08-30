import 'dart:convert';
import 'dart:io';

import 'package:cardoctor_chatapp/src/utils/custom_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

import '../../cardoctor_chatapp.dart';
import '../../model/send_message_request.dart';
import '../../model/send_message_response.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/receiver_card.dart';
import '../../widget/sender_card.dart';
import '../contains.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatAppCarDoctorUtilOption data;
  final Function(Map<String, dynamic>) press;
  const ChatDetailScreen({
    Key? key,
    required this.data,
    required this.press,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late final IOWebSocketChannel channel;
  late ScrollController scrollController;
  final List<SendMessageResponse> listMessage = [];

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
    controller = TextEditingController();

    channel = IOWebSocketChannel.connect(
      Uri.parse('wss://' +
          widget.data.cluseterID +
          '.piesocket.com/v3/' +
          widget.data.groupName +
          '?api_key=' +
          widget.data.apiKey +
          '&notify_self=1'),
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
              print("socket");
              print(message);

              setState(() {
                listMessage.insert(
                    0, SendMessageResponse.fromMap(json.decode(message)));
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

  // Future addMessage(SendMessageRequest message) async {
  //   try {
  //     channel.sink.add(json.encode(message));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        title: Row(
          children: [
            Image.asset(
              'assets/imgs/ic_button_send.png',
              width: 32,
              height: 32,
              package: Consts.packageName,
            ),
            Text(
              widget.data.groupName ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .h5Bold
                  .copyWith(color: kColorDark1),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFF6F6F6),
      ),
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
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index > 0 &&
                              listMessage[index].username ==
                                  widget.data.idUserFrom &&
                              listMessage[index - 1].username ==
                                  widget.data.idUserFrom) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SenderCard(
                                data: listMessage[index],
                              ),
                            );
                          }
                          if (listMessage[index].username ==
                              widget.data.idUserFrom) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: SenderCard(
                                data: listMessage[index],
                              ),
                            );
                          }
                          if (index > 0 &&
                              listMessage[index].username !=
                                  widget.data.idUserFrom &&
                              listMessage[index - 1].username !=
                                  widget.data.idUserFrom) {
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
                      var message = SendMessageRequest(
                        originalMessage: '',
                        attachmentType: TypeSend.images.name,
                        linkPreview:
                            "http://localhost:6666/chat-service/api/v1/files/2023/08/others/santafe.jpeg",
                        username: widget.data.idUserFrom,
                        groupName: widget.data.groupName,
                      );
                      // addMessage(message);
                      widget.press(message.toMap());
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
                          attachmentType: '',
                          linkPreview:
                              "http://localhost:6666/chat-service/api/v1/files/2023/08/others/santafe.jpeg",
                          username: widget.data.idUserFrom,
                          groupName: widget.data.groupName,
                        );
                        // addMessage(message);
                        widget.press(message.toMap());

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
