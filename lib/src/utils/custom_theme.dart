import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../page/contains.dart';

extension CustomTheme on TextTheme {
  TextStyle get titleLarge => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 36,
      fontWeight: FontWeight.bold,
      height: 44 / 36);

  TextStyle get title1 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 38 / 32);
  }

  TextStyle get title2 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 32 / 28);
  }

  TextStyle get title3 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        height: 30 / 22);
  }

  TextStyle get title4 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        height: 28 / 20);
  }

  TextStyle get title6 {
    return GoogleFonts.inter(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        height: 28 / 20);
  }

  TextStyle get body1 => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 22 / 16);

  TextStyle get body1Bold => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      height: 22 / 16);

  TextStyle get body2Bold => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 20 / 14);

  TextStyle get body2 => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 22 / 14);

  TextStyle get buttonNormal => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 18 / 14);

  TextStyle get subTitleRegular => GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 24 / 14,
      );

  TextStyle get tooltip => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 16 / 12);

  TextStyle get labelLargeText => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 16 / 12);

  TextStyle get labelNormalText => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 19 / 14);

  TextStyle get h5Regular {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 25 / 18);
  }

  TextStyle get subTitle {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14);
  }

  TextStyle get textRegular => GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 17 / 12,
      );

  TextStyle get smallNormal => GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
      );

  TextStyle get labelHighLight {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 22 / 16);
  }

  TextStyle get labelHighLight2 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 32 / 20);
  }

  TextStyle get h5Bold {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 25 / 18);
  }

  TextStyle get subTitle16 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 22 / 16);
  }

  TextStyle get text16 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 22 / 16);
  }

  TextStyle get text17 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 19.36 / 16);
  }

  TextStyle get text20 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 32 / 20);
  }

  TextStyle get text14 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 14,
        fontWeight: FontWeight.w300,
        height: 20 / 14);
  }

  TextStyle get label14 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 22 / 14);
  }

  TextStyle get bold14 {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 20 / 14);
  }

  TextStyle get h4Bold {
    return GoogleFonts.inter(
        color: kColorDark1,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        height: 27 / 20);
  }

  TextStyle get text12 => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 18 / 12);
  TextStyle get text10 => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 10,
      fontWeight: FontWeight.w300,
      height: 12 / 10);

  TextStyle get textSmall => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12);

  TextStyle get title5 => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 24 / 18);
  TextStyle get content1 => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 16,
      fontWeight: FontWeight.w300,
      height: 24 / 16);
  TextStyle get smallMedium => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12);

  TextStyle get text28W700 => GoogleFonts.inter(
      color: kColorDark1,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 32 / 28);
}
