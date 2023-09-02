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
  final Function(Map<String, dynamic>) pressPickImage;
  final Function(Map<String, dynamic>) pressPickFiles;
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
    required this.pressPickImage,
    required this.pressPickFiles,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  var _scrollController = ScrollController();
  var _isVisible = true;
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
    FilePickerResult? files = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (files != null) {
      filesList = files.paths.map((path) => File(path!)).toList();

      String fileName = filesList[0].path.split('/').last;
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

  scrollToEnd() {
    final double end = scrollController.position.maxScrollExtent;
    _scrollController.animateTo(end,
        curve: Curves.easeIn, duration: Duration(seconds: 1));
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
    _scrollController.addListener(() {
      if (_scrollController.position.minScrollExtent ==
          _scrollController.offset) {
        print("scroll to top");
      }
      if (_scrollController.position.atEdge) {
        if (scrollController.position.pixels > 0) {
          if (_isVisible) {
            setState(() {
              _isVisible = false;
            });
          }
        }
      } else {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
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
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
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
                    title: widget.nameTitle ?? '',
                    isList: false,
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              controller: _scrollController,
                              reverse: true,
                              itemCount: listMessage.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                DateTime date1 = DateTime.parse(
                                    listMessage[index].updatedAtStr!);
                                DateTime date2 = DateTime.parse(
                                    listMessage[index + 1].updatedAtStr!);
                                // if (date1.day != date2.day ||
                                //     date1.month != date2.month ||
                                //     date1.year != date2.year) {}
                                if (listMessage[index].username ==
                                        widget.data.userIDReal &&
                                    listMessage[index + 1].username ==
                                        widget.data.userIDReal) {
                                  List<FormFile> sampleFile = [];
                                  List<FormItem> sample = [];
                                  List<String> images = [];
                                  if (listMessage[index].type == 2) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.value!) {
                                      sample.add(e);
                                    }
                                  } else if (listMessage[index].type == 5) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueImage!) {
                                      images.add(e.image!);
                                    }
                                  } else if (listMessage[index].type == 6) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueFiles!) {
                                      sampleFile.add(e);
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 4),
                                    child: SenderCard(
                                      listFiles: sampleFile,
                                      data: listMessage[index],
                                      listForm: sample,
                                      listImages: images,
                                    ),
                                  );
                                }
                                if (listMessage[index].username ==
                                        widget.data.userIDReal &&
                                    listMessage[index + 1].username !=
                                        widget.data.userIDReal) {
                                  List<FormFile> sampleFile = [];
                                  List<FormItem> sample = [];
                                  List<String> images = [];
                                  if (listMessage[index].type == 2) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.value!) {
                                      sample.add(e);
                                    }
                                  } else if (listMessage[index].type == 5) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueImage!) {
                                      images.add(e.image!);
                                    }
                                  } else if (listMessage[index].type == 6) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueFiles!) {
                                      sampleFile.add(e);
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 8),
                                    child: SenderCard(
                                      listFiles: sampleFile,
                                      data: listMessage[index],
                                      listForm: sample,
                                      listImages: images,
                                    ),
                                  );
                                }
                                if (index > 0 &&
                                    listMessage[index].username !=
                                        widget.data.userIDReal &&
                                    listMessage[index - 1].username !=
                                        widget.data.userIDReal) {
                                  List<FormFile> sampleFile = [];
                                  List<FormItem> sample = [];
                                  List<String> images = [];
                                  if (listMessage[index].type == 2) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.value!) {
                                      sample.add(e);
                                    }
                                  } else if (listMessage[index].type == 5) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueImage!) {
                                      images.add(e.image!);
                                    }
                                  } else if (listMessage[index].type == 6) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueFiles!) {
                                      sampleFile.add(e);
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 4),
                                    child: ReceiverCard(
                                      listFiles: sampleFile,
                                      onlyOnePerson: true,
                                      data: listMessage[index],
                                      listForm: sample,
                                      listImages: images,
                                    ),
                                  );
                                } else {
                                  List<FormFile> sampleFile = [];
                                  List<FormItem> sample = [];
                                  List<String> images = [];
                                  if (listMessage[index].type == 2) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.value!) {
                                      sample.add(e);
                                    }
                                  } else if (listMessage[index].type == 5) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueImage!) {
                                      images.add(e.image!);
                                    }
                                  } else if (listMessage[index].type == 6) {
                                    var x = FormData.fromJson(json.decode(
                                        listMessage[index].originalMessage!));
                                    for (var e in x.valueFiles!) {
                                      sampleFile.add(e);
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 8),
                                    child: ReceiverCard(
                                      listFiles: sampleFile,
                                      onlyOnePerson: false,
                                      listForm: sample,
                                      data: listMessage[index],
                                      listImages: images,
                                    ),
                                  );
                                }
                                return const Text("Error");
                              },
                            ),
                    ),
                  ),
                  if (widget.stackWidget != null) widget.stackWidget!,
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    color: Colors.white,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await getImage();
                            var message = {
                              'key': 'image',
                              'list': filesList,
                            };
                            widget.pressPickImage(message);
                          },
                          child: Image.asset(
                            'assets/imgs/ic_gallary.png',
                            height: 24,
                            width: 24,
                            package: Consts.packageName,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await getFile();

                            var message = {
                              'key': 'files',
                              'list': filesList,
                            };
                            widget.pressPickFiles(message);
                          },
                          child: Image.asset(
                            'assets/imgs/ic_link.png',
                            height: 24,
                            width: 24,
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
          ),
          if (_isVisible)
            Positioned(
              right: 24,
              bottom: 24,
              child: GestureDetector(
                onTap: () {
                  scrollToEnd();
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_downward_rounded,
                    size: 24,
                    color: Color(0xFFFF8D4E),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

enum TypeSend { text, images, files }
