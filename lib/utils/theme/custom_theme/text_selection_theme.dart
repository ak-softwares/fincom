import 'package:flutter/material.dart';

class AppTextSelectionTheme {
  AppTextSelectionTheme._();

  static TextSelectionThemeData lightTextSelectionTheme = TextSelectionThemeData(
    cursorColor: Colors.black, // standard for light backgrounds
    selectionColor: Color(0x6633B5E5), // semi-transparent blue (Material default)
    selectionHandleColor: Color(0xFF33B5E5), // blue handle (Material default)
  );

  static TextSelectionThemeData darkTextSelectionTheme = TextSelectionThemeData(
    cursorColor: Colors.white, // standard for dark backgrounds
    selectionColor: Color(0x66FFFFFF), // translucent white
    selectionHandleColor: Color(0xFFFFFFFF), // white handle
  );
}
