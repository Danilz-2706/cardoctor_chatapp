import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cardoctor_chatapp/src/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../page/contains.dart';
import 'ImageVideoUploadManager/pic_image_video.dart';

enum ToastType { SUCCESS, WARNING, ERROR, INFORM }

class Utils {
  static void showSnackBar(BuildContext context, String? text) {
    if (Utils.isEmpty(text)) return;
    final snackBar = SnackBar(
      content: Text(text ?? ""),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static bool isEmpty(Object? text) {
    if (text is String) return text.isEmpty;
    if (text is List) return text.isEmpty;
    return text == null;
  }

  static bool isEmptyArray(List? list) {
    return list == null || list.isEmpty;
  }

  static bool isInteger(num value) =>
      value is int || value == value.roundToDouble();

  static Color parseStringToColor(String? color, {Color? defaultColor}) {
    if (Utils.isEmpty(color)) {
      return defaultColor ?? Colors.black;
    } else {
      return Color(int.parse('0xff${color!.trim().substring(1)}'));
    }
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static String convertVNtoText(String str) {
    str = str.replaceAll(RegExp(r'[à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ]'), 'a');

    str = str.replaceAll(RegExp(r'[è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ]'), 'e');
    str = str.replaceAll(RegExp(r'[ì|í|ị|ỉ|ĩ]'), 'i');
    str = str.replaceAll(RegExp(r'[ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ]'), 'o');
    str = str.replaceAll(RegExp(r'[ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ]'), 'u');
    str = str.replaceAll(RegExp(r'[ỳ|ý|ỵ|ỷ|ỹ]'), 'y');
    str = str.replaceAll(RegExp(r'[đ]'), 'd');

    str = str.replaceAll(RegExp(r'[À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ]'), 'A');
    str = str.replaceAll(RegExp(r'[È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ]'), 'E');
    str = str.replaceAll(RegExp(r'[Ì|Í|Ị|Ỉ|Ĩ]'), 'I');
    str = str.replaceAll(RegExp(r'[Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ]'), 'O');
    str = str.replaceAll(RegExp(r'[Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ]'), 'U');
    str = str.replaceAll(RegExp(r'[Ỳ|Ý|Ỵ|Ỷ|Ỹ]'), 'Y');
    str = str.replaceAll(RegExp(r'[Đ]'), 'D');
    return str;
  }

  static String formatMessageDate(String messageDate) {
    try {
      var date = DateTime.parse(messageDate);

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
        ).format(date);
      }
    } catch (e) {
      return '';
    }
  }

  static bool formatMessageDateCheck(String dateBefor, String dateAfter) {
    try {
      var dateBefor1 = DateTime.parse(dateBefor);
      var dateAfter1 = DateTime.parse(dateAfter);

      Duration difference = dateBefor1.difference(
          DateTime(dateAfter1.year, dateAfter1.month, dateAfter1.day));

      if (difference.inDays == 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static void onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static void showToast(BuildContext context, String? text,
      {ToastType? type = ToastType.ERROR, bool? isPrefixIcon = true}) {
    Color backgroundColor = Color(0xFFFEECEF);
    Color iconColor = Color(0xFFF14C68);
    Color textColor = Color(0xFF2D2D2D);

    onWidgetDidBuild(() {
      print('vao day');
      FToast fToast = FToast();
      fToast.init(context);
      fToast.removeQueuedCustomToasts();
      Widget toast = Container(
        width: 1,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: backgroundColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isPrefixIcon == true
                ? Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Image.asset(
                      'assets/imgs/ic_warning.png',
                      height: 24,
                      color: iconColor,
                      package: Consts.packageName,
                    ),
                  )
                : Container(),
            Expanded(
              child: Text(text ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .subTitle
                      .copyWith(color: textColor)),
            ),
          ],
        ),
      );

      print('text');
      print(text);
      if (text != null && text.isNotEmpty) {
        fToast.showToast(
          child: toast,
          gravity: ToastGravity.TOP,
          positionedToastBuilder: (_, child) {
            return Positioned(
              top: MediaQuery.of(_).padding.top,
              left: 0,
              right: 0,
              child: child,
            );
          },
          toastDuration: const Duration(seconds: 3),
        );
      }
    });
  }

  static Future<Map<String, dynamic>> onResultListMedia(
      BuildContext context, List<XFile> images, bool isImage) async {
    if (images.isEmpty) return {};
    if (images.length > MAX_SEND_IMAGE_CHAT) {
      return {
        'type': 'MAX_SEND_IMAGE_CHAT',
        'text':
            'Chỉ được tải lên tối đa ${MAX_SEND_IMAGE_CHAT.toString()} ${isImage ? "ảnh" : "video"}!'
      };
    }
    bool isValidSize = await PickImagesUtils.isValidSizeOfFiles(
        files: images, limitSizeInMB: LIMIT_CHAT_IMAGES_IN_MB);
    if (!isValidSize) {
      print('cho nay 2');

      Utils.showToast(
        context,
        "Tệp vượt quá giới hạn, xin vui lòng thử lại",
        type: ToastType.ERROR,
      );
      return {
        'type': 'LIMIT_CHAT_IMAGES_IN_MB',
        'text': 'Tệp vượt quá giới hạn, xin vui lòng thử lại'
      };
    }

    return {
      'type': 'done',
      'key': 'files',
      'list': images,
    };
  }
}
