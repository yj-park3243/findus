import 'package:findus/constants/common_sizes.dart';
import 'package:findus/constants/main_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData lightTheme = ThemeData(
    fontFamily: 'SF-Pro-Regular',
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: MainColor.blue,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
      centerTitle: false,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'SF-Pro-Regular',
        color: Colors.grey[800],
        fontSize: CommonSize.appbarTitleFontSize,
        fontWeight: FontWeight.w800,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.grey[800]),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed, //선택된 버튼 이동/고정
      selectedLabelStyle:
          TextStyle(fontSize: CommonSize.bottomNaviLabelFontSize),
      unselectedLabelStyle:
          TextStyle(fontSize: CommonSize.bottomNaviLabelFontSize),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100))),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      primary: MainColor.blue,
      elevation: 0,
      side: const BorderSide(color: MainColor.blue, width: 1),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100))),
    )),
    // inputDecorationTheme: InputDecorationTheme(
    //   contentPadding: const EdgeInsets.symmetric(
    //       vertical: CommonGap.m, horizontal: CommonGap.xs),
    //   hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
    //   enabledBorder: const UnderlineInputBorder(
    //     borderSide: BorderSide(color: Colors.grey),
    //   ),
    //   disabledBorder: const UnderlineInputBorder(
    //     borderSide: BorderSide(color: Colors.grey),
    //   ),
    //   focusedBorder: const UnderlineInputBorder(
    //     borderSide: BorderSide(color: Colors.grey),
    //   ),
    //   errorBorder: const UnderlineInputBorder(
    //       borderSide: BorderSide(color: Colors.red),
    //       borderRadius: BorderRadius.zero),
    //   focusedErrorBorder: const UnderlineInputBorder(
    //       borderSide: BorderSide(color: Colors.red),
    //       borderRadius: BorderRadius.zero),
    // ),
    indicatorColor: Colors.grey);
