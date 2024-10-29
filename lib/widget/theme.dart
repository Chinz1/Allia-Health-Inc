import 'package:allia_health_inc_test_app/widget/strings.dart';
import 'package:flutter/material.dart';

// app theme
final baseTheme = ThemeData.light();

final ThemeData appTheme = baseTheme.copyWith(
  primaryColor: appColors.purple,
  scaffoldBackgroundColor: appColors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: appColors.white,
    elevation: 4,
    foregroundColor: appColors.grey,
    titleTextStyle: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: appColors.textColor,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: appColors.purple,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: kFontFamily,
      color: appColors.red,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: appColors.white,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
);

const appColors = ThemeModel(
  purple: Color(0xff17004A),
  green: Color(0xff00C598),
  grey: Color(0xff777676),
  textColor: Color(0xff000D09),
  white: Colors.white,
  black: Colors.black,
  red: Color(0xffE33C2F),
  lightGrey: Color(0xffF9F9F9),
  transparent: Colors.transparent,
  lightGreen: Color(0xffF0FFFC),
  mediumGrey: Color(0xff979797),
);

class ThemeModel {
  const ThemeModel({
    required this.purple,
    required this.green,
    required this.grey,
    required this.textColor,
    required this.white,
    required this.black,
    required this.red,
    required this.lightGrey,
    required this.transparent,
    required this.lightGreen,
    required this.mediumGrey,
  });

  final Color purple;
  final Color white;
  final Color green;
  final Color grey;
  final Color textColor;
  final Color black;
  final Color red;
  final Color lightGrey;
  final Color transparent;
  final Color lightGreen;
  final Color mediumGrey;
}
