import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: Color(0xffa3866e),//
    primaryColorDark: Color(0xFFA5A58D),
    primaryColorLight: Color(0xFFDDBEA9),
    focusColor: Color(0xFFC09984),
    scaffoldBackgroundColor: Color(0xFFFFECD9),
    canvasColor: Color(0xffffd394), // color of disable choice chips
    // textTheme: GoogleFonts.playTextTheme().copyWith(),
    fontFamily: 'sut',
    inputDecorationTheme: const InputDecorationTheme(
      prefixIconColor: Color(0xffa3866e),
      suffixIconColor: Color(0xffa3866e),
      labelStyle: TextStyle(
        color: Color(0xffa3866e), // Change label text color for all TextFields
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
