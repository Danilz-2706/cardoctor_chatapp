import 'package:flutter/material.dart';

const kTextInputColors = Color.fromRGBO(176, 176, 176, 1);
const kTextWhiteColors = Color(0xFFFCFCFD);
const kTextBlackColors = Color.fromRGBO(10, 11, 9, 1);
const kTextGreyColors = Color.fromRGBO(139, 141, 140, 1);
const kTextGreyDarkColors = Color.fromRGBO(123, 125, 124, 1);
const kBgColors = Color.fromRGBO(246, 246, 246, 1);
const kWhiteColors = Color.fromRGBO(255, 255, 255, 1);
const kBlackColors = Color.fromRGBO(29, 29, 29, 1);
const kColorDark1 = Color(0xFF0A0B09);
const kColordark5 = Color(0xFF6B6D6C);
const kColordark12 = Color(0xFFE6E6E3);
const kColorlightestGray = Color(0xFFEEF4FF);
const kColordarkger1 = Color(0xFFED1F42);

const kColorneutral7 = Color(0xFFF3F3F3);

const kLinearColor = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFE11A1A),
    Color(0xFFFF8D4E),
  ],
  stops: [0.1119, 0.8481],
  // transform: GradientRotation(
  //     339 * 3.14 / 180), // Convert the angle from degrees to radians
);

const double kSpacing = 8.0;

class Consts {
  static String packageName = 'cardoctor_chatapp';
  static const String restaurantType = 'RESTAURANT';
  static const String parkingType = 'PARKING';
  static const String gasStationType = 'GAS_STATION';
  static const String washType = 'CAR_WASH';
  static const String streetParkingType = 'PARKING_LOT';
  static const String garage = 'GARAGE';
  static const String DATE_TIME_FORMAT_NOTIFICATION = "dd/MM/yyyy, HH:mm";
}
