import 'package:flutter/material.dart';

//TODO Determine theme colors
class Themes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      background: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
    ),
  );
}
