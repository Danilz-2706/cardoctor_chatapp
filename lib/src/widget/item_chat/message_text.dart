import 'package:flutter/material.dart';

import '../../model/send_message_response.dart';
import '../../page/contains.dart';
import '../../utils/EmojiDetect/emoji_detect.dart';

class MessageText extends StatelessWidget {
  const MessageText({
    Key? key,
    required this.data,
    required this.press,
    required this.isLeft,
  }) : super(key: key);

  final SendMessageResponse data;
  final VoidCallback press;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: isLeft
                ? MediaQuery.of(context).size.width - 160
                : MediaQuery.of(context).size.width - 100),
        child: GestureDetector(
          onTap: press,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: isAllEmoji(data.originalMessage!.trim()) ? 0.0 : 12,
                vertical: 8),
            decoration: BoxDecoration(
              color: isAllEmoji(data.originalMessage!.trim())
                  ? null
                  : kWhiteColors,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              data.originalMessage!.trim(),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: isAllEmoji(data.originalMessage!.trim()) ? 32 : 16,
                color: kTextBlackColors,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
