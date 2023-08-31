import 'dart:convert';
import 'dart:io';

import 'package:cardoctor_chatapp/src/widget/text_field_form.dart';
import 'package:cardoctor_chatapp/src/widget/title_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/form_text.dart';
import '../model/send_message_response.dart';
import '../page/contains.dart';
import 'label_drop_down.dart';

class ReceiverCard extends StatefulWidget {
  final SendMessageResponse data;
  final bool onlyOnePerson;

  const ReceiverCard({
    Key? key,
    required this.onlyOnePerson,
    required this.data,
  }) : super(key: key);

  @override
  State<ReceiverCard> createState() => _ReceiverCardState();
}

class _ReceiverCardState extends State<ReceiverCard> {
  List<FormItem> listForm = [];
  List<File> listImages = [];
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          height: 32,
          width: 32,
          child: widget.onlyOnePerson
              ? const SizedBox()
              : Image.asset(
                  "assets/imgs/ic_link.png",
                  package: Consts.packageName,
                  height: 32,
                  width: 32,
                  fit: BoxFit.contain,
                ),
        ),
        const SizedBox(width: 12),
        if (listForm.isEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 160),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: kWhiteColors,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.data.originalMessage ?? '',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    color: kTextBlackColors,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        if (listForm.isEmpty) const SizedBox(width: 8),
        if (listForm.isNotEmpty)
          Align(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 100),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(
                    listForm.length,
                    (index) {
                      // if (listForm[index].type == 'title') {
                      //   return Padding(
                      //     padding: const EdgeInsets.only(bottom: 8.0),
                      //     child: TitleForm(listForm: listForm[index]),
                      //   );
                      // }
                      // if (listForm[index].type == 'dropdown') {
                      //   return Padding(
                      //     padding: const EdgeInsets.only(bottom: 8.0),
                      //     child: LabelDropDownForm(listForm: listForm[index]),
                      //   );
                      // }
                      // if (listForm[index].type == 'textfield') {
                      //   return Padding(
                      //     padding: const EdgeInsets.only(bottom: 8.0),
                      //     child: TextFieldForm(listForm: listForm[index]),
                      //   );
                      // }
                      return Container();
                    },
                  ),
                ),
              ),
            ),
          ),
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
      ],
    );
  }
}
