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
import '../../model/create_room_chat_response.dart';
import '../../model/form_text.dart';
import '../../model/send_message_request.dart';
import '../../model/send_message_response.dart';
import '../../widget/appbar.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/receiver_card.dart';
import '../../widget/sender_card.dart';
import '../contains.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatAppCarDoctorUtilOption data;
  final dynamic dataRoom;
  final String idSender;
  final Function(Map<String, dynamic>) press;
  final VoidCallback pressBack;
  final Widget? stackWidget;
  final String? nameTitle;
  const ChatDetailScreen({
    Key? key,
    required this.data,
    required this.press,
    required this.pressBack,
    required this.dataRoom,
    this.stackWidget,
    required this.idSender,
    this.nameTitle,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late final IOWebSocketChannel channel;
  FocusNode _focusNode = FocusNode();
  late ScrollController scrollController;
  List<SendMessageResponse> listMessage = [];

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

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      print('Người dùng đã không nhấn vào TextInput');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    List<SendMessageResponse> sample = [];
    if (widget.data.historyChat != null) {
      for (var e in widget.data.historyChat) {
        print("du lieu: " + e.toString());
        sample.add(SendMessageResponse.fromMap(e));
      }
      setState(() {
        listMessage.addAll(sample);
      });
    }

    channel = IOWebSocketChannel.connect(
      Uri.parse('wss://' +
          widget.data.cluseterID +
          '.piesocket.com/v3/' +
          widget.data.groupName +
          '?api_key=' +
          widget.data.apiKey +
          '&notify_self=1'),
    );
    print('Connect socket');
    connectWebsocket();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    channel.sink.close();
    controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  connectWebsocket() {
    print('socketreturn');

    try {
      channel.stream.asBroadcastStream().listen(
            (message) {
              print('socketreturn123');
              print(message);
              listMessage.insert(
                  0, SendMessageResponse.fromMap(json.decode(message)));
              setState(() {});
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
      // appBar: appBar(
      //   context,
      //   onBackPress: widget.pressBack,
      //   centerTitle: true,
      //   rightWidget: const SizedBox(
      //     width: 28,
      //     height: 28,
      //   ),
      //   title: Row(
      //     children: [
      //       Image.asset(
      //         'assets/imgs/avatar.png',
      //         width: 28,
      //         height: 28,
      //         package: Consts.packageName,
      //       ),
      //       const SizedBox(width: 12),
      //       Text(
      //         widget.nameTitle ?? widget.dataRoom['convName'] ?? '',
      //         textAlign: TextAlign.center,
      //         overflow: TextOverflow.ellipsis,
      //         style: Theme.of(context).textTheme.h5Bold.copyWith(
      //               color: kColorDark1,
      //             ),
      //       ),
      //     ],
      //   ),
      //   backgroundColor: const Color(0xFFF6F6F6),
      // ),
      backgroundColor: kBgColors,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBarReview(
              avatar: 'assets/imgs/avatar.png',
              press: widget.pressBack,
              title: widget.nameTitle ?? widget.dataRoom['convName'] ?? '',
              isList: false,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: listMessage.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            "Gửi tin nhắn đến chuyên gia của chúng tôi để tư vấn nhé!",
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
                                  widget.data.userIDReal &&
                              listMessage[index - 1].username ==
                                  widget.data.userIDReal) {
                            List<FormItem> sample = [];
                            if (listMessage[index].type == 2) {
                              var x = FormData.fromJson(json
                                  .decode(listMessage[index].originalMessage!));
                              for (var e in x.value!) {
                                sample.add(e);
                              }
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SenderCard(
                                data: listMessage[index],
                                listForm: sample,
                              ),
                            );
                          }
                          if (listMessage[index].username ==
                              widget.data.userIDReal) {
                            List<FormItem> sample = [];
                            if (listMessage[index].type == 2) {
                              var x = FormData.fromJson(json
                                  .decode(listMessage[index].originalMessage!));
                              for (var e in x.value!) {
                                sample.add(e);
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SenderCard(
                                data: listMessage[index],
                                listForm: sample,
                              ),
                            );
                          }
                          if (index > 0 &&
                              listMessage[index].username !=
                                  widget.data.userIDReal &&
                              listMessage[index - 1].username !=
                                  widget.data.userIDReal) {
                            List<FormItem> sample = [];
                            if (listMessage[index].type == 2) {
                              var x = FormData.fromJson(json
                                  .decode(listMessage[index].originalMessage!));
                              for (var e in x.value!) {
                                sample.add(e);
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: ReceiverCard(
                                onlyOnePerson: true,
                                data: listMessage[index],
                              ),
                            );
                          } else {
                            List<FormItem> sample = [];
                            if (listMessage[index].type == 2) {
                              var x = FormData.fromJson(json
                                  .decode(listMessage[index].originalMessage!));
                              for (var e in x.value!) {
                                sample.add(e);
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: ReceiverCard(
                                onlyOnePerson: false,
                                data: listMessage[index],
                              ),
                            );
                          }
                        },
                      ),
              ),
            ),
            if (widget.stackWidget != null) widget.stackWidget!,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              color: Colors.white,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // await getImage();
                      // var message = SendMessageRequest(
                      //   originalMessage: '',
                      //   attachmentType: TypeSend.images.name,
                      //   linkPreview:
                      //       "http://localhost:6666/chat-service/api/v1/files/2023/08/others/santafe.jpeg",
                      //   username: idUserFrom,
                      //   groupName: widget.data.groupName,
                      // );
                      // addMessage(message);
                      // widget.press(message.toMap());
                    },
                    child: Image.asset(
                      'assets/imgs/ic_gallary.png',
                      height: 28,
                      width: 28,
                      package: Consts.packageName,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // await getFile();
                      // print(filesList);
                    },
                    child: Image.asset(
                      'assets/imgs/ic_link.png',
                      height: 28,
                      width: 28,
                      package: Consts.packageName,
                    ),
                  ),
                  Container(
                    width: 204,
                    height: 52,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Color.fromRGBO(246, 246, 246, 1),
                    ),
                    child: TextField(
                      focusNode: _focusNode,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                        } else {}
                      },
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 26, 26, 26),
                      ),
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
                          linkPreview: "",
                          username: widget.idSender,
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
