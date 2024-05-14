import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData firstAppTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(0, 191, 166, 100),
    brightness: Brightness.light,
  ),
  textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 62,
        fontWeight: FontWeight.bold,
      ),
      // ···
      titleLarge: GoogleFonts.roboto(
        fontSize: 25,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: GoogleFonts.roboto(),
      displaySmall: GoogleFonts.roboto(),
    ),
  
);
