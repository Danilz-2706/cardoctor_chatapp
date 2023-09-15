import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/send_message_response.dart';
import '../../page/contains.dart';
import '../../utils/EmojiDetect/emoji_detect.dart';

class MessageText extends StatelessWidget {
  const MessageText({
    Key? key,
    required this.data,
    required this.press,
    required this.isLeft,
    this.background,
    this.textColor,
    this.linear,
  }) : super(key: key);

  final SendMessageResponse data;
  final VoidCallback press;
  final bool isLeft;

  final Color? background;
  final Color? textColor;
  final LinearGradient? linear;

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
              vertical: isAllEmoji(data.originalMessage!.trim()) ? 0.0 : 8,
            ),
            decoration: BoxDecoration(
              color: background ?? (!isLeft ? null : kWhiteColors),
              borderRadius: BorderRadius.circular(16),
              gradient: !isLeft
                  ? !isAllEmoji(data.originalMessage!.trim())
                      ? linear ?? kLinearColor
                      : null
                  : null,
            ),
            child: Text(
              data.originalMessage!.trim(),
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                color: textColor ?? (!isLeft ? kWhiteColors : kTextBlackColors),
                fontSize: isAllEmoji(data.originalMessage!.trim()) ? 32 : 16,
                fontWeight: FontWeight.w400,
                height:
                    isAllEmoji(data.originalMessage!.trim()) ? null : 24 / 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
