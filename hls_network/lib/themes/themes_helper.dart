import 'package:flutter/material.dart';

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
      elevation: 0,
      backgroundColor: appBarColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor:  appBarColor,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: tealColor,
      selectionColor: Colors.blue,
      selectionHandleColor: Colors.blue,
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
    cardColor: textColor,
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
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: tealColor,
      selectionColor: Colors.blue,
      selectionHandleColor: Colors.blue,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: tealColor,
    ),
  );
}
