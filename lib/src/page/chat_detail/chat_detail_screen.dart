// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:web_socket_channel/io.dart';

import 'package:cardoctor_chatapp/src/utils/custom_theme.dart';

import '../../cardoctor_chatapp.dart';
import '../../model/create_room_chat_response.dart';
import '../../model/form_text.dart';
import '../../model/send_message_request.dart';
import '../../model/send_message_response.dart';
import '../../utils/ImageVideoUploadManager/pic_image_video.dart';
import '../../utils/utils.dart';
import '../../widget/appbar.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/receiver_card.dart';
import '../../widget/sender_card.dart';
import '../contains.dart';
import 'input_chat_app.dart';
import 'list_message.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatAppCarDoctorUtilOption data;
  final Color color;
  final dynamic dataRoom;
  final String idSender;
  final Function(Map<String, dynamic>) press;
  final Function(Map<String, dynamic>) pressPickImage;
  final Function(Map<String, dynamic>) pressPickFiles;
  final Function(Map<String, dynamic>) pressPickVideo;
  final Function(Map<String, dynamic>) errorGetFile;

  final VoidCallback pressCallAudio;
  final VoidCallback pressCallVideo;

  final Function(Map<String, dynamic>) loadMoreHistory;
  final Function(Map<String, dynamic>) typing;
  final Widget listHistoryChat;
  final Widget typingChat;
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
    required this.loadMoreHistory,
    required this.listHistoryChat,
    required this.typing,
    required this.typingChat,
    required this.color,
    required this.pressPickVideo,
    required this.pressCallAudio,
    required this.pressCallVideo,
    required this.errorGetFile,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController? messageListScrollController = ScrollController();
  late final IOWebSocketChannel channel;

  bool typing = false;

  @override
  void initState() {
    super.initState();

    try {
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
    } catch (e) {
      print('Error when connect socket');
      print(e);
    }
  }

  connectWebsocket() {
    try {
      channel.stream.asBroadcastStream().listen(
            (message) {
              var x = json.decode(message);
              if (x['typing'] != null) {
                if (x['id'] != widget.idSender) {
                  typing = x['typing'];
                } else {
                  print('bug in typing - package chat app');
                }
              }
              if (mounted) {
                setState(() {});
              }
            },
            cancelOnError: true,
            onError: (error) {
              if (kDebugMode) {
                print('loi ket noi socket');
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

  Future addMessage(dynamic message) async {
    try {
      channel.sink.add(json.encode(message));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColors,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_sharp, color: Color(0xFF0A0B09)),
            onPressed: widget.pressBack,
          ),
        ),
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: Image.asset(
                'assets/imgs/avatar.png',
                height: 28,
                width: 28,
                package: Consts.packageName,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.nameTitle ?? '',
                style: GoogleFonts.inter(
                    color: const Color(0xFF0A0B09),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 22 / 16),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: widget.pressCallAudio,
            child: SvgPicture.asset(
              'assets/imgs/call-calling.svg',
              semanticsLabel: 'Acme Logo',
              height: 24,
              width: 24,
              package: Consts.packageName,
            ),
          ),
          SizedBox(width: 16),
          GestureDetector(
            onTap: widget.pressCallVideo,
            child: SvgPicture.asset(
              'assets/imgs/video.svg',
              semanticsLabel: 'Acme Logo',
              height: 24,
              width: 24,
              package: Consts.packageName,
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8.0),
            widget.listHistoryChat,
            if (widget.stackWidget != null) widget.stackWidget!,
            const SizedBox(height: 8),
            if (typing) widget.typingChat,
            const SizedBox(height: 8),
            InputChatApp(
              errorGetFile: (p0) {
                widget.errorGetFile.call(p0);
              },
              color: widget.color,
              typing: (p0) {
                widget.typing(p0);
                addMessage(p0);
              },
              data: widget.data,
              idSender: widget.idSender,
              press: (p0) {
                if (mounted) {
                  setState(() {
                    typing = false;
                  });
                }
                addMessage(
                  {
                    "id": null,
                    "groupId": null,
                    "userId": null,
                    "profileName": "",
                    "originalMessage": "${p0['originalMessage']}",
                    "filteredMessage": "${p0['originalMessage']}",
                    "attachmentType": "${p0['attachmentType']}",
                    "attachment": null,
                    "linkPreview": "",
                    "username": widget.data.userIDReal,
                    "groupName": widget.data.groupName,
                    "type": null,
                    "createdAtStr": DateTime.now().toString(),
                    "updatedAtStr": DateTime.now().toString(),
                    "createdAt": DateTime.now().toString(),
                    "updatedAt": DateTime.now().toString()
                  },
                );

                widget.press(p0);
              },
              pressPickFiles: (p0) {
                addMessage(
                  {
                    "id": null,
                    "groupId": null,
                    "userId": null,
                    "profileName": "",
                    "originalMessage": "${p0['originalMessage']}",
                    "filteredMessage": "${p0['originalMessage']}",
                    "attachmentType": "${p0['attachmentType']}",
                    // "attachmentType": "123",
                    "attachment": null,
                    "linkPreview": "",
                    "username": widget.data.userIDReal,
                    "groupName": widget.data.groupName,
                    "type": 6,
                    "createdAtStr": DateTime.now().toString(),
                    "updatedAtStr": DateTime.now().toString(),
                    "createdAt": DateTime.now().toString(),
                    "updatedAt": DateTime.now().toString()
                  },
                );
                widget.pressPickFiles(p0);
              },
              pressPickImage: (p0) {
                addMessage(
                  {
                    "id": null,
                    "groupId": null,
                    "userId": null,
                    "profileName": "",
                    "originalMessage": "${p0['originalMessage']}",
                    "filteredMessage": "${p0['originalMessage']}",
                    "attachmentType": "${p0['attachmentType']}",
                    "attachment": null,
                    "linkPreview": "",
                    "username": widget.data.userIDReal,
                    "groupName": widget.data.groupName,
                    "type": 5,
                    "createdAtStr": DateTime.now().toString(),
                    "updatedAtStr": DateTime.now().toString(),
                    "createdAt": DateTime.now().toString(),
                    "updatedAt": DateTime.now().toString()
                  },
                );
                widget.pressPickImage(p0);
              },
              dataRoom: widget.dataRoom,
              pressPickVideo: (p0) {
                addMessage(
                  {
                    "id": null,
                    "groupId": null,
                    "userId": null,
                    "profileName": "",
                    "originalMessage": "${p0['originalMessage']}",
                    "filteredMessage": "${p0['originalMessage']}",
                    "attachmentType": "${p0['attachmentType']}",
                    "attachment": null,
                    "linkPreview": "",
                    "username": widget.data.userIDReal,
                    "groupName": widget.data.groupName,
                    "type": 7,
                    "createdAtStr": DateTime.now().toString(),
                    "updatedAtStr": DateTime.now().toString(),
                    "createdAt": DateTime.now().toString(),
                    "updatedAt": DateTime.now().toString()
                  },
                );
                widget.pressPickVideo(p0);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> pending(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.all(20),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24))),
        backgroundColor: Colors.white,
        child: Container(
          width: 343,
          height: 170,
          padding: const EdgeInsets.all(24),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 15,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 295,
                child: Text(
                  'Chức năng đang phát triển',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Thoát'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
