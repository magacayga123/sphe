import 'package:flutter/material.dart';

ThemeData get darkTheme {
  return ThemeData.dark().copyWith(
    primaryColor: Colors.deepOrange,
    colorScheme: ColorScheme.dark().copyWith(
        primary: Colors.deepOrange,
        secondary: Colors.grey.shade300,
        tertiary: Colors.yellow),
  );
}

ThemeData get lightTheme {
  return ThemeData.light().copyWith(
    primaryColor: Colors.deepOrange,
    colorScheme: ColorScheme.light().copyWith(
        primary: Colors.deepOrange,
        secondary: Color.fromARGB(255, 12, 11, 11),
        tertiary: Colors.yellow),
  );
}
