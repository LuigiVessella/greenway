import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData firstAppTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(56,127,117,1.0)).copyWith(
    surfaceTint: Colors.transparent,
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
