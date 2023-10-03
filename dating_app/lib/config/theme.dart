import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: Color(0xFF6C6F5C),
    primaryColorDark: Color(0xFFA5A58D),
    primaryColorLight: Color(0xFFDDBEA9),
    focusColor: Color(0xFFC09984),
    scaffoldBackgroundColor: Color(0xFFFDE8D7),
    textTheme: GoogleFonts.playTextTheme().copyWith(),
     inputDecorationTheme: const InputDecorationTheme(
      prefixIconColor: Color(0xFF6C6F5C),
      suffixIconColor: Color(0xFF6C6F5C),
      labelStyle: TextStyle(
        color: Color(0xFF6C6F5C), // Change label text color for all TextFields
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF6C6F5C), // Change underline color for all TextFields
        ),
      ),
       // Change cursor color for all TextFields
    ),
    textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF6C6F5C), // Change cursor color for all TextFields
        ),
  );
}
