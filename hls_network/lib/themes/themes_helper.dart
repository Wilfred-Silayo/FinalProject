import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class Pallete {
  // Colors
  static const Color blackColor = Color.fromRGBO(1, 1, 1, 1);
  static const Color greyColor = Color.fromRGBO(26, 39, 45, 1);
  static const Color drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const Color whiteColor = Colors.white;
  static const Color tealColor = Color.fromRGBO(55, 103, 138, 1);
  static const Color redColor = Color.fromARGB(255, 223, 77, 126);
  static const Color backgroundColor = Color.fromRGBO(19, 28, 33, 1);
  static const Color textColor = Color.fromRGBO(241, 241, 242, 1);
  static const Color appBarColor = Color.fromRGBO(31, 44, 52, 1);
  static const Color messageColor = Color.fromRGBO(5, 96, 98, 1);
  static const Color senderMessageColor = Color.fromRGBO(37, 45, 49, 1);
  static const Color tabColor = Color.fromRGBO(0, 167, 131, 1);
  static const Color searchBarColor = Color.fromRGBO(50, 55, 57, 1);
  static const Color dividerColor = Color.fromRGBO(37, 45, 50, 1);
  static const Color chatBarMessage = Color.fromRGBO(30, 36, 40, 1);
  static const Color mobileChatBoxColor = Color.fromRGBO(31, 44, 52, 1);

  // dark Theme
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: appBarColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: appBarColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: tealColor,
    ),
    colorScheme: ColorScheme.dark(
      background: Colors.black,
      primary: Colors.grey[900]!,
      secondary: Colors.grey[800]!,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: tealColor,
    ),
  );

//light theme
  static var lightModeAppTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: tealColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    colorScheme: ColorScheme.light(
      background: Colors.grey[300]!,
      primary: Colors.grey[200]!,
      secondary: Colors.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: tealColor,
    ),
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({ThemeMode mode = ThemeMode.light})
      : _mode = mode,
        super(
          Pallete.lightModeAppTheme,
        ) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
      loadSystemUiOverlay();
    } else {
      _mode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
      loadSystemUiOverlay();
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
      prefs.setString('theme', 'light');
      loadSystemUiOverlay();
    } else {
      _mode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
      prefs.setString('theme', 'dark');
      loadSystemUiOverlay();
    }
  }

  void loadSystemUiOverlay() {
    if (_mode == ThemeMode.light) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Pallete.tealColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Pallete.appBarColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    }
  }
}
