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
import '../utils/download_open_file.dart';
import '../utils/emoji_detect.dart';
import 'DownloadManager/download_all_file_type.dart';
import 'label_drop_down.dart';
import 'text_field_form.dart';
import 'title_form.dart';

class SenderCard extends StatefulWidget {
  final SendMessageResponse data;
  final List<FormItem> listForm;
  final List<String> listImages;
  final List<FormFile> listFiles;
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
            Text(
              widget.data.createdAtStr != null
                  ? DateFormat('HH:mm')
                      .format(DateTime.parse(widget.data.createdAtStr!))
                  : DateFormat('HH:mm').format(DateTime.now()),
              style: const TextStyle(
                  color: kTextGreyColors,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 8),
            if (widget.listForm.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 100),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        widget.listForm.length,
                        (index) {
                          if (widget.listForm[index].type == 'title') {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child:
                                  TitleForm(listForm: widget.listForm[index]),
                            );
                          }
                          if (widget.listForm[index].type == 'dropdown') {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: LabelDropDownForm(
                                  listForm: widget.listForm[index]),
                            );
                          }
                          if (widget.listForm[index].type == 'textfield') {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextFieldForm(
                                  listForm: widget.listForm[index]),
                            );
                          }

                          if (widget.listForm[index].type == 'image') {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => const SizedBox(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                imageUrl: widget.listForm[index].text ?? '',
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            if (widget.listImages.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 100),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                        widget.listImages.length,
                        (index) {
                          return CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.4,
                            placeholder: (context, url) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),
                            errorWidget: (context, url, error) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: const Icon(Icons.error),
                            ),
                            imageUrl: widget.listImages[index],
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.4,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [],
                                  image: DecorationImage(
                                    onError: (exception, stackTrace) {},
                                    isAntiAlias: true,
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            if (widget.listFiles.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 100),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                        widget.listFiles.length,
                        (index) {
                          return InkWell(
                            onTap: process == true
                                ? () {}
                                : () async {
                                    await MobileDownloadService().download(
                                      url: widget.listFiles[index].url!,
                                      fileName: basename(
                                          widget.listFiles[index].path!),
                                      context: this.context,
                                      isOpenAfterDownload: true,
                                      downloading: (p0) {
                                        setState(() {
                                          process = p0;
                                        });
                                      },
                                    );
                                  },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(243, 243, 243, 1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (process == true)
                                    const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(),
                                    ),
                                  if (process == false)
                                    const Icon(
                                      Icons.insert_drive_file_rounded,
                                      color: Color.fromRGBO(107, 109, 108, 1),
                                      size: 24,
                                    ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        basename(widget.listFiles[index].path!)
                                            .toString(),
                                        maxLines: 3,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromRGBO(10, 11, 9, 1)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            if (widget.listForm.isEmpty &&
                widget.listImages.isEmpty &&
                widget.listFiles.isEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 100),
                  child: GestureDetector(
                    onTap: () {
                      if (!widget.old) {
                        setState(() {
                          hidden ? hidden = false : hidden = true;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              isAllEmoji(widget.data.originalMessage!.trim())
                                  ? 0.0
                                  : 12,
                          vertical: 8),
                      decoration: BoxDecoration(
                        gradient:
                            isAllEmoji(widget.data.originalMessage!.trim())
                                ? null
                                : kLinearColor,
                        borderRadius:
                            isAllEmoji(widget.data.originalMessage!.trim())
                                ? null
                                : BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.data.originalMessage!.trim(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize:
                              isAllEmoji(widget.data.originalMessage!.trim())
                                  ? 32
                                  : 16,
                          color: kTextWhiteColors,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
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
