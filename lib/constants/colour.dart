import 'package:flutter/material.dart';

class Pallete {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static const greenColor = Colors.green;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;
  static var peachColor = const Color(0xFFeed9c4);
  static var purpleColor = const Color(0xFF6750a4);
  static var purpleAccentColor = const Color(0xFFf7f2f9);
  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: blackColor,
      cardColor: greyColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: drawerColor,
        iconTheme: IconThemeData(
          color: whiteColor,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: drawerColor,
      ),
      primaryColor: redColor,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF6750a4),
        secondary: blueColor,
        surface: greyColor,
        onSurface: whiteColor,
      ));

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
  );
}
