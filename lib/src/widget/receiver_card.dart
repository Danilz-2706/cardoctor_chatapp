import 'package:flutter/material.dart';

import '../model/form_text.dart';
import '../model/send_message_response.dart';
import '../utils/utils.dart';
import 'item_chat/message_avatar.dart';
import 'item_chat/message_file.dart';
import 'item_chat/message_form.dart';
import 'item_chat/message_image.dart';
import 'item_chat/message_text.dart';
import 'item_chat/message_time.dart';
import 'item_chat/message_video.dart';

class ReceiverCard extends StatefulWidget {
  final SendMessageResponse data;
  final bool onlyOnePerson;
  final List<String> listImages;
  final List<FormFile> listFiles;
  final List<FormItem> listForm;
  final String urlVideo;
  final bool old;
  final bool seen;

  final Color? receiverBackground;
  final Color? receiverTextColor;
  final LinearGradient? receiverLinear;

  const ReceiverCard({
    Key? key,
    required this.onlyOnePerson,
    required this.data,
    required this.listImages,
    required this.listFiles,
    required this.listForm,
    required this.old,
    required this.seen,
    required this.urlVideo,
    this.receiverBackground,
    this.receiverTextColor,
    this.receiverLinear,
  }) : super(key: key);

  @override
  State<ReceiverCard> createState() => _ReceiverCardState();
}

class _ReceiverCardState extends State<ReceiverCard> {
  bool hidden = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.old || hidden) const SizedBox(height: 8),
        if (widget.old || hidden)
          Text(
            Utils.formatMessageDate(widget.data.createdAtStr!),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromRGBO(175, 177, 175, 1),
              fontSize: 12,
            ),
          ),
        if (widget.old || hidden) const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: widget.onlyOnePerson
                  ? const SizedBox()
                  : const MessageAvatar(urlAvatar: '', size: 45),
            ),
            const SizedBox(width: 8),
            if (widget.listForm.isEmpty &&
                widget.listImages.isEmpty &&
                widget.listFiles.isEmpty &&
                widget.urlVideo.isEmpty)
              MessageText(
                background: widget.receiverBackground,
                textColor: widget.receiverTextColor,
                linear: widget.receiverLinear,
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
            if (widget.listForm.isNotEmpty)
              MessageForm(
                data: widget.listForm,
                isLeft: true,
              ),
            if (widget.listImages.isNotEmpty)
              MessageImage(
                listImages: widget.listImages,
                data: widget.data,
                isLeft: true,
              ),
            if (widget.listFiles.isNotEmpty)
              MessageFile(
                listFiles: widget.listFiles,
                isLeft: true,
              ),
            if (widget.urlVideo.isNotEmpty)
              // MessageVideo(
              //   urlVideo: widget.urlVideo,
              //   isLeft: true,
              // ),
              const SizedBox(width: 8),
            if (widget.listImages.isEmpty && widget.urlVideo.isEmpty)
              MessageTime(
                data: widget.data,
              ),
          ],
        ),
      ],
    );
  }
}
