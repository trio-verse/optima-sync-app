import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class AppTheme {
  static final _border = OutlineInputBorder(
    borderSide: const BorderSide(color: AppPallete.borderColor, width: 3),
    borderRadius: BorderRadius.circular(10),
  );
  static final lightModeTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: const Color.fromARGB(255, 173, 168, 168),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(20),
      enabledBorder: _border,
      focusedBorder: _border,
    ),
  );
}
