import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: Color(0xff000000),//
    primaryColorDark: Color(0xFFA5A58D),
    primaryColorLight: Color(0xFFDDBEA9),
    focusColor: Color(0xFFC09984),
    scaffoldBackgroundColor: Color(0xfff0ede6),
    canvasColor: Color(0xffFBC982), // color of disable choice chips ffd394
    // textTheme: GoogleFonts.playTextTheme().copyWith(),
    fontFamily: 'sut',
    inputDecorationTheme: const InputDecorationTheme(
      prefixIconColor: Color(0xff000000),
      suffixIconColor: Color(0xff000000),
      labelStyle: TextStyle(
        color: Color(0xff000000), // Change label text color for all TextFields
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffa3866e), // Change underline color for all TextFields
        ),
      ),
      // Change cursor color for all TextFields
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xffa3866e), // Change cursor color for all TextFields
    ),
  );
}
