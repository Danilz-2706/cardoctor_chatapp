import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/send_message_response.dart';
import '../../page/contains.dart';

class MessageTime extends StatelessWidget {
  const MessageTime({
    Key? key,
    required this.data,
  }) : super(key: key);

  final SendMessageResponse data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data.createdAtStr != null
          ? DateFormat('HH:mm').format(DateTime.parse(data.createdAtStr!))
          : DateFormat('HH:mm').format(DateTime.now()),
      style: const TextStyle(
          color: kTextGreyColors, fontSize: 12, fontWeight: FontWeight.w400),
    );
  }
}
