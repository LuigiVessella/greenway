import 'package:flutter/material.dart';

final ThemeData firstAppTheme = ThemeData(
  useMaterial3: true,
  
  primaryColor: const Color.fromRGBO(0, 191, 166, 100),
  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(0, 191, 166, 100),
    // ···
    brightness: Brightness.light,
  ),

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
);
