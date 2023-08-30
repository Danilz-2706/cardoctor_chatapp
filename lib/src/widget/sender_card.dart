import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/send_message_response.dart';
import '../page/contains.dart';

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
  @override
  void initState() {
    if (widget.data.type == 2) {
      var x = json.decode(widget.data.originalMessage!);
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
        Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 100),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: kLinearColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: widget.data.type == 2
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [],
                    )
                  : Text(
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
