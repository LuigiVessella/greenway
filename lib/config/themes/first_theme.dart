import 'package:flutter/material.dart';

final ThemeData firstAppTheme = ThemeData(
  useMaterial3: true,
  
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(0, 191, 166, 100),
    brightness: Brightness.light,
  ), 
  // Potrebbero essere necessarie ulteriori personalizzazioni alla textTheme
  textTheme: const TextTheme(
    // ...
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20), 
        bottomRight: Radius.circular(20),
      ),
    ),
  ),
);