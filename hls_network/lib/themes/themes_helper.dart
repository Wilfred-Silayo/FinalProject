import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hls_network/themes/colors.dart';

class ThemeHelper {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Pallete.whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.tealColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.tealColor,
    ),
  );
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 36, 35, 35),
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.tealColor,
    ),
  );
  static Future<ThemeMode> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return ThemeMode.values[prefs.getInt('themeMode') ?? 0];
  }

  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
  }

  static SystemUiOverlayStyle getSystemUIOverlayStyle(ThemeMode themeMode, BuildContext context) {
    if (themeMode == ThemeMode.light) {
      return SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Color.fromRGBO(55, 103, 138, 1),
        systemNavigationBarIconBrightness: Brightness.light,
      );
    } else if (themeMode == ThemeMode.dark) {
      return SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Color.fromARGB(255, 36, 35, 35),
        systemNavigationBarIconBrightness: Brightness.light,
      );
    } else {
      Brightness brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) {
        return SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: Color.fromARGB(255, 36, 35, 35), 
          systemNavigationBarIconBrightness: Brightness.light,
        );
      } else {
        return SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: Color.fromRGBO(55, 103, 138, 1),
          systemNavigationBarIconBrightness: Brightness.light,
        );
      }
    }
  }
}