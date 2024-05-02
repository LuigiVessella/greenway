import 'package:flutter/material.dart';

final ThemeData firstAppTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(0, 191, 166, 100),
   
      brightness: Brightness.light,
    ),
    // Potrebbero essere necessarie ulteriori personalizzazioni alla textTheme
    textTheme: const TextTheme(
      // ...TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 56.0,
        fontWeight: FontWeight.bold,
        color: Color(0xff007bff),
      ),
      displayMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 45.0,
        fontWeight: FontWeight.bold,
        color: Color(0xff007bff),
      ),
      displaySmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
        color: Color(0xff007bff),
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Color(0xff007bff),
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: Color(0xff007bff),
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Color(0xff007bff),
      ),
      titleLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Color(0xff007bff),
      ),
      titleMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Color(0xff007bff),
      ),
      titleSmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: Color(0xff007bff),
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Color(0xff000000),
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Color(0xff000000),
      ),
      bodySmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: Color(0xff000000),
      ),
      labelLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Color(0x0a000000),
      ),
      labelMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Color(0x0a000000),
      ),
      labelSmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: Color(0x0a000000),
      ),
    ),
    chipTheme: const ChipThemeData());
