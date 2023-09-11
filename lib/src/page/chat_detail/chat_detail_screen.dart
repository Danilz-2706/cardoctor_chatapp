// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  final dynamic dataRoom;
  final String idSender;
  final Function(Map<String, dynamic>) press;
  final Function(Map<String, dynamic>) pressPickImage;
  final Function(Map<String, dynamic>) pressPickFiles;
  final Function(Map<String, dynamic>) loadMoreHistory;
  final Widget listHistoryChat;

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
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController? messageListScrollController = ScrollController();

  bool typing = false;

  @override
  void initState() {
    super.initState();

    print('Connect socket');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            widget.listHistoryChat,
            if (widget.stackWidget != null) widget.stackWidget!,
            const SizedBox(height: 8),
            if (typing)
              Container(
                height: 40,
                color: Colors.red,
                width: double.infinity,
              ),
            InputChatApp(
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
                // addMessage(SendMessageRequest.fromMap(p0));
              },
              dataRoom: widget.dataRoom,
            ),
          ],
        ),
      ),
    );
  }
}
