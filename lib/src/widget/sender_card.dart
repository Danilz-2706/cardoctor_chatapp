import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardoctor_chatapp/src/model/form_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../model/send_message_response.dart';
import '../page/contains.dart';
import '../utils/DownloadManager/download_all_file_type.dart';
import '../utils/EmojiDetect/emoji_detect.dart';
import 'item_chat/message_file.dart';
import 'item_chat/message_form.dart';
import 'item_chat/message_image.dart';
import 'item_chat/message_text.dart';
import 'item_chat/message_time.dart';
import 'item_chat/message_video.dart';
import 'label_drop_down.dart';
import 'text_field_form.dart';
import 'title_form.dart';

class SenderCard extends StatefulWidget {
  final SendMessageResponse data;
  final List<FormItem> listForm;
  final List<String> listImages;
  final List<FormFile> listFiles;
  final String urlVideo;

  final bool old;
  final bool seen;

  const SenderCard({
    super.key,
    required this.data,
    required this.listForm,
    required this.listImages,
    required this.listFiles,
    required this.old,
    required this.seen,
    required this.urlVideo,
  });

  @override
  State<SenderCard> createState() => _SenderCardState();
}

class _SenderCardState extends State<SenderCard> {
  // List<FormItem> listForm = [];
  bool process = false;
  bool hidden = false;
  late String dateTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.old || hidden)
          Text(
            formatMessageDate(DateTime.parse(widget.data.createdAtStr!)),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromRGBO(175, 177, 175, 1),
              fontSize: 12,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.listImages.isEmpty && widget.urlVideo.isEmpty)
              MessageTime(
                data: widget.data,
              ),
            const SizedBox(width: 8),
            if (widget.listForm.isNotEmpty)
              MessageForm(
                data: widget.listForm,
                isLeft: false,
              ),
            if (widget.listImages.isNotEmpty)
              MessageImage(
                listImages: widget.listImages,
                data: widget.data,
                isLeft: false,
              ),
            if (widget.listFiles.isNotEmpty)
              MessageFile(
                listFiles: widget.listFiles,
                isLeft: false,
              ),
            if (widget.urlVideo.isNotEmpty)
              MessageVideo(
                urlVideo: widget.urlVideo,
                isLeft: false,
              ),
            if (widget.listForm.isEmpty &&
                widget.listImages.isEmpty &&
                widget.listFiles.isEmpty &&
                widget.urlVideo.isEmpty)
              MessageText(
                data: widget.data,
                press: () {
                  if (!widget.old) {
                    setState(() {
                      hidden ? hidden = false : hidden = true;
                    });
                  }
                },
                isLeft: true,
              ),
          ],
        ),
      ],
    );
  }

  String formatMessageDate(DateTime messageDate) {
    try {
      var date = DateTime.parse(widget.data.createdAtStr!);

      DateTime now = DateTime.now();
      Duration difference =
          now.difference(DateTime(date.year, date.month, date.day));

      if (difference.inDays == 0) {
        return "today";
      } else if (difference.inDays == 1) {
        return "yesterday";
      } else {
        return DateFormat(
          "HH:mm, dd 'tháng' MM",
        ).format(messageDate);
      }
    } catch (e) {
      return '';
    }
  }
}
