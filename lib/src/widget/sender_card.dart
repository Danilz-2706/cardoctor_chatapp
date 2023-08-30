import 'dart:convert';

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
  const SenderCard({
    super.key,
    required this.data,
  });

  @override
  State<SenderCard> createState() => _SenderCardState();
}

class _SenderCardState extends State<SenderCard> {
  List<FormItem> listForm = [];
  @override
  void initState() {
    if (widget.data.type == 2) {
      List<FormItem> sample = [];
      var x = FormData.fromJson(json.decode(widget.data.originalMessage!));
      for (var e in x.value!) {
        sample.add(e);
      }
      setState(() {
        listForm.addAll(sample);
      });
    }

    super.initState();
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
        if (listForm.isNotEmpty)
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
                    listForm.length,
                    (index) {
                      if (listForm[index].type == 'title') {
                        return TitleForm(listForm: listForm[index]);
                      }
                      if (listForm[index].type == 'dropdown') {
                        return LabelDropDownForm(listForm: listForm[index]);
                      }
                      if (listForm[index].type == 'textfield') {
                        return TextFieldForm(listForm: listForm[index]);
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ),
          ),
        if (listForm.isEmpty)
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
