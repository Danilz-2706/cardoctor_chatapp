import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cardoctor_chatapp/src/widget/item_chat/message_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as p;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardoctor_chatapp/src/model/form_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../model/send_message_response.dart';
import '../page/contains.dart';
import '../utils/DownloadManager/download_all_file_type.dart';
import '../utils/EmojiDetect/emoji_detect.dart';
import '../utils/utils.dart';
import 'item_chat/message_file.dart';
import 'item_chat/message_form.dart';
import 'item_chat/message_image.dart';
import 'item_chat/message_text.dart';
import 'item_chat/message_time.dart';
import 'item_chat/message_video.dart';
import 'label_drop_down.dart';
import 'text_field_form.dart';
import 'title_form.dart';

enum StatusMessage { send, seen, sending, error }

class SenderCard extends StatefulWidget {
  final SendMessageResponse data;
  final List<FormItem> listForm;
  final List<String> listImages;
  final List<FormFile> listFiles;
  final List<FormService> listService;
  final String? urlVideo;

  final bool old;
  final StatusMessage statusMessage;

  final Color? senderBackground;
  final Color? senderTextColor;
  final LinearGradient? senderLinear;
  final bool? local;

  const SenderCard({
    super.key,
    required this.data,
    required this.listForm,
    required this.listImages,
    required this.listFiles,
    required this.listService,
    required this.old,
    required this.statusMessage,
    this.urlVideo,
    this.senderBackground,
    this.senderTextColor,
    this.senderLinear,
    this.local = false,
  });

  @override
  State<SenderCard> createState() => _SenderCardState();
}

class _SenderCardState extends State<SenderCard>
    with AutomaticKeepAliveClientMixin {
  // List<FormItem> listForm = [];
  bool process = false;
  bool hidden = false;
  late String dateTime;
  String? _thumbnailUrl;
  Uint8List? _bytes;

  String? _thumbnailFile;

  Uint8List? _thumbnailData;

  void generateThumbnail() async {
    try {
      print('lam thumbnail moi2');

      if (widget.urlVideo != null) {
        if (widget.local!) {
          print('yyyyyyyyyy');
          print(widget.urlVideo);

          _thumbnailUrl = await VideoThumbnail.thumbnailFile(
            video: widget.urlVideo ?? '',
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.PNG,
          );
          print('yyyyyyyyyy');
          print(_thumbnailUrl);
        } else if (widget.urlVideo!.isNotEmpty) {
          _thumbnailUrl = await VideoThumbnail.thumbnailFile(
            video: Uri.parse(widget.urlVideo ?? '').toString(),
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.WEBP,
          );
          // if (mounted)
        }
        setState(() {});
      }
    } catch (e) {
      print("Loi");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    print('lam thumbnail moi');
    generateThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.old || hidden) const SizedBox(height: 4),
        if (widget.old || hidden)
          Text(
            Utils.formatMessageDate(widget.data.createdAtStr!),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromRGBO(175, 177, 175, 1),
              fontSize: 12,
            ),
          ),

        if (widget.old || hidden) const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.listImages.isEmpty &&
                widget.urlVideo == null &&
                widget.listService.isEmpty &&
                widget.listForm.isEmpty)
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
                local: widget.local ?? false,
              ),
            if (widget.listService.isNotEmpty)
              MessageService(
                  listService: widget.listService,
                  data: widget.data,
                  isLeft: false),
            if (widget.listFiles.isNotEmpty)
              MessageFile(
                listFiles: widget.listFiles,
                isLeft: false,
              ),
            if (widget.urlVideo != null &&
                (_thumbnailUrl != null || _bytes != null))
              MessageVideo(
                urlVideo: widget.urlVideo ?? '',
                isLeft: false,
                thumbnailUrl: _thumbnailUrl ?? '',
                data: widget.data,
                local: widget.local ?? false,
              ),
            if (widget.listForm.isEmpty &&
                widget.listImages.isEmpty &&
                widget.listFiles.isEmpty &&
                widget.listService.isEmpty &&
                widget.urlVideo == null)
              MessageText(
                background: widget.senderBackground,
                textColor: widget.senderTextColor,
                linear: widget.senderLinear,
                data: widget.data,
                press: () {
                  if (!widget.old) {
                    setState(() {
                      hidden ? hidden = false : hidden = true;
                    });
                  }
                },
                isLeft: false,
              ),
          ],
        ),
        // if (widget.old || hidden)
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       CircleAvatar(
        //         radius: 8.0,
        //         backgroundImage:
        //             NetworkImage("https://via.placeholder.com/12x12"),
        //         backgroundColor: Colors.transparent,
        //       ),
        //     ],
        //   ),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
