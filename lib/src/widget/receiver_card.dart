import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/send_message_response.dart';
import '../page/contains.dart';

class ReceiverCard extends StatelessWidget {
  final SendMessageResponse data;
  final bool onlyOnePerson;

  const ReceiverCard({
    Key? key,
    required this.onlyOnePerson,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          height: 32,
          width: 32,
          child: onlyOnePerson
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
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 160),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: kWhiteColors,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                data.originalMessage ?? '',
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
        const SizedBox(width: 8),
        Text(
          data.createdAtStr != null
              ? DateFormat('HH:mm').format(DateTime.parse(data.createdAtStr!))
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
