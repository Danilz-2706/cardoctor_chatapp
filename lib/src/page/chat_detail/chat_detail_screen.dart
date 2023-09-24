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
                print("typing");
                print(message);
                if (x['id'] != widget.idSender) {
                  typing = x['typing'];
                } else {
                  print('aaaa');
                }
              }

              setState(() {});
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
            const SizedBox(width: 12),
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
            onTap: () async {},
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
            onTap: () async {},
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
              color: widget.color,
              typing: (p0) {
                widget.typing(p0);
                addMessage(p0);
              },
              data: widget.data,
              idSender: widget.idSender,
              press: (p0) {
                print('press to send Text');
                print(p0);
                setState(() {
                  typing = false;
                });
                print(typing);

                widget.press(p0);
              },
              pressPickFiles: (p0) {
                print('press to send Files');
                print(p0);
                widget.pressPickFiles(p0);
              },
              pressPickImage: (p0) {
                print('press to send Image');
                print(p0);
                widget.pressPickImage(p0);
                // addMessage(SendMessageRequest.fromMap(p0));
              },
              dataRoom: widget.dataRoom,
              pressPickVideo: (p0) {
                print('press to send Image');
                print(p0);
                widget.pressPickVideo(p0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
