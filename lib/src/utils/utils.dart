import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ImageVideoUploadManager/pic_image_video.dart';

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

  static void onResultListMedia(List<XFile> images, bool isImage) async {
    if (images.isEmpty) return;
    if (images.length > MAX_SEND_IMAGE_CHAT) {
      // ToastUtil.showToast(context,
      //     "Chỉ được tải lên tối đa ${MAX_SEND_IMAGE_CHAT.toString()} ${isImage ? "ảnh" : "video"}!");
      return;
    }
    bool isValidSize = await PickImagesUtils.isValidSizeOfFiles(
        files: images, limitSizeInMB: LIMIT_CHAT_IMAGES_IN_MB);
    if (!isValidSize) {
      // ToastUtil.showToast(
      //     context, "Tệp vượt quá giới hạn, xin vui lòng thử lại");
      return;
    }
    var message = {
      'key': 'files',
      'list': images,
    };
    print(message);
    // widget.pressPickFiles(message);
  }
}
