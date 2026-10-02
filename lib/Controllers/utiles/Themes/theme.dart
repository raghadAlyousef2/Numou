import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTheme {
  static var theme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF1183b7),
      secondary: const Color(0xFFfbcd22),
      tertiary: const Color(0xFF082d3d),
      surface: const Color(0xFFf9f9f9),
    ),
    textTheme: GoogleFonts.changaTextTheme(),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(Color(0xFF58CC02)), // <-- color here
      trackColor: WidgetStateProperty.all(Colors.black12),
      trackBorderColor: WidgetStateProperty.all(Colors.transparent),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(8),
    ),
  );
}


class DarkTheme {
  static var theme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.deepPurple,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.changaTextTheme(),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(Color(0xFF58CC02)), // <-- color here
      trackColor: WidgetStateProperty.all(Colors.black12),
      trackBorderColor: WidgetStateProperty.all(Colors.transparent),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(8),
    ),
  );
}

