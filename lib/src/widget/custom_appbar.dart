import 'package:cardoctor_chatapp/src/page/contains.dart';
import 'package:cardoctor_chatapp/src/utils/custom_theme.dart';
import 'package:flutter/material.dart';

import 'single_tap_detector.dart';

AppBar appBar(
  BuildContext context, {
  dynamic title,
  Widget? leadingWidget,
  Widget? rightWidget,
  Color? backgroundColor,
  Color? iconColor,
  double? elevation,
  bool centerTitle = true,
  TextStyle? textStyle,
  VoidCallback? onBackPress,
}) {
  return AppBar(
    backgroundColor: backgroundColor ?? Colors.white,
    centerTitle: centerTitle,
    elevation: elevation ?? 0,
    leadingWidth: 50,
    titleSpacing: 0,
    leading: leadingWidget ??
        (Navigator.of(context).canPop() == true
            ? SingleTapDetector(
                onTap: () {
                  if (onBackPress != null) {
                    onBackPress.call();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, bottom: 5, top: 5, right: 5),
                  child: Image.asset(
                    'assets/imgs/ic_back.png',
                    color: iconColor,
                    package: Consts.packageName,
                  ),
                ),
              )
            : null),
    // iconTheme: IconThemeData(color: iconColor ?? R.color.black),
    title: title is String
        ? Text(
            title ?? '',
            textAlign: TextAlign.center,
            style: textStyle ??
                Theme.of(context).textTheme.h5Bold.copyWith(color: kColorDark1),
          )
        : title,
    actions: rightWidget == null ? null : [rightWidget],
  );
}
