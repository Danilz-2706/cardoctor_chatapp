import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardoctor_chatapp/src/model/form_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/send_message_response.dart';
import '../page/contains.dart';
import 'label_drop_down.dart';
import 'text_field_form.dart';
import 'title_form.dart';

class SenderCard extends StatefulWidget {
  final SendMessageResponse data;
  final List<FormItem> listForm;
  const SenderCard({
    super.key,
    required this.data,
    required this.listForm,
  });

  @override
  State<SenderCard> createState() => _SenderCardState();
}

class _SenderCardState extends State<SenderCard> {
  // List<FormItem> listForm = [];
  List<File> listImages = [];
  @override
  void initState() {
    // else if (widget.data.attachmentType == 'image') {
    //   listImages.add(File(widget.data.originalMessage!));
    // }

    super.initState();
    // if (widget.data.type == 2) {
    //   print("decode cho nay");
    //   List<FormItem> sample = [];
    //   var x = FormData.fromJson(json.decode(widget.data.originalMessage!));
    //   for (var e in x.value!) {
    //     sample.add(e);
    //   }
    //   listForm.addAll(sample);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                          child: TitleForm(listForm: widget.listForm[index]),
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
                          child:
                              TextFieldForm(listForm: widget.listForm[index]),
                        );
                      }

                      if (widget.listForm[index].type == 'image') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
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
        if (widget.listForm.isEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 100),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: kLinearColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.data.originalMessage ?? 'Lỗi',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 16,
                    color: kTextWhiteColors,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
