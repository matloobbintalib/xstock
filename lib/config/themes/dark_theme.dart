import 'package:flutter/material.dart';

/// headline large 24 800
/// headline large 20 800
/// headline large 18 800

/// title large 18 500
/// title medium 16 500
/// title small 14 500

/// body large 16 normal
/// body medium 14 normal
/// body small 12 normal

final darkTheme = _getTheme();

const _primary = Colors.deepPurple;
const _light = Colors.blueGrey;
const _secondary = Colors.amber;

const _darkBlue = Color(0xff007BFF);

const _background = Color(0xFF121212);
const _light1 = Colors.white;
const _light2 = Colors.white70;
const _darker = Colors.black87;
const _dark1 = Color(0xF4121212);
const _dark2 = Color(0xF2171616);
const _dark3 = Color(0xff232323);

const _grey = Colors.grey;
const _divider = Colors.grey;
const _disabled = Colors.grey;

const _red = Color(0XFFCF6679);

ThemeData _getTheme() {
  final colorScheme = _lightColorScheme;

  final textTheme = _getTextTheme(colorScheme);
  final primaryTextTheme = textTheme.apply(
    displayColor: colorScheme.onPrimary,
    bodyColor: colorScheme.onPrimary,
  );

  final buttonTextStyle = textTheme.titleMedium;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    splashFactory: InkSplash.splashFactory,

    // set colors
    colorScheme: colorScheme,
    textTheme: textTheme,
    primaryTextTheme: primaryTextTheme,
    scaffoldBackgroundColor: colorScheme.background,
    disabledColor: _disabled,

    /// ************************************** BottomNavigationBar **************************************
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _dark3,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _darkBlue,
      unselectedItemColor: _grey,
      selectedIconTheme: IconThemeData(color: _darkBlue),
      unselectedIconTheme: IconThemeData(color: _grey),
      selectedLabelStyle: TextStyle(color: _darkBlue),
      unselectedLabelStyle: TextStyle(color: _grey),
    ),

    /// ************************************** AppBarTheme **************************************
    appBarTheme: const AppBarTheme(
      backgroundColor: _dark3,
      elevation: 1,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _light1,
      ),
    ),

    /// ************************************** InputDecoration **************************************
    inputDecorationTheme: InputDecorationTheme(
      fillColor: _dark2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: _light.withOpacity(.15),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: _primary,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: _red,
          width: 1.5,
        ),
      ),
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      hintStyle: TextStyle(
        color: _light1.withOpacity(.5),
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      labelStyle: const TextStyle(
        color: Colors.black38,
        fontWeight: FontWeight.normal,
      ),
    ),

    /// ************************************** CardTheme **************************************

    cardTheme: const CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        side: BorderSide(
          width: 1,
          color: _divider,
        ),
      ),
      color: _dark1,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
    ),

    /// ************************************** DialogTheme **************************************
    dialogTheme: const DialogTheme(
      backgroundColor: _dark3,
      surfaceTintColor: _dark3,

      /// titleTextStyle: textTheme.titleLarge,
    ),

    /// ************************************** DividerTheme **************************************
    dividerTheme: const DividerThemeData(
      color: _divider,
      space: 1,
      thickness: 1,
    ),

    /// ************************************** ButtonTheme **************************************
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: _buttonShape,
        padding: _buttonPadding,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: buttonTextStyle,
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: _buttonShape,
        padding: _buttonPadding,
        side: BorderSide(
          color: colorScheme.primary,
          width: 1,
        ),
        foregroundColor: colorScheme.primary,
        textStyle: buttonTextStyle,
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: _buttonShape,
        padding: _buttonPadding,
        foregroundColor: colorScheme.primary,
        textStyle: buttonTextStyle,
      ),
    ),

    /// ************************************** SnackBarTheme **************************************
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: _darker,

      /// contentTextStyle: primaryTextTheme.bodyLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),

    /// ************************************** PopupMenu **************************************

    popupMenuTheme: PopupMenuThemeData(
      color: _background,
      surfaceTintColor: colorScheme.background,
    ),

    /// ************************************** BottomSheet **************************************
    bottomSheetTheme: const BottomSheetThemeData(
      showDragHandle: false,
      backgroundColor: _dark3,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
        ),
      ),
    ),

    /// ************************************** FloatingActionButton **************************************
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.secondary,
      foregroundColor: Colors.white,
      iconSize: 24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
    ),

    /// ************************************** Page Transition Builder **************************************
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

/// ************************************** Color Scheme **************************************

final _lightColorScheme = ColorScheme(
  brightness: Brightness.dark,
  // Primary
  primary: _primary,
  onPrimary: _light1,
  primaryContainer: _primary.withOpacity(0.2),
  onPrimaryContainer: _light1,
  // Secondary
  secondary: _secondary,
  onSecondary: _dark1,
  secondaryContainer: _secondary.withOpacity(0.2),
  onSecondaryContainer: _dark1,
  // Error
  error: _red,
  onError: _light1,
  // Background
  background: _background,
  onBackground: _dark1,
  // Surface
  surface: _light1,
  onSurface: _dark1,
  // Outline
  outline: _divider,
);

/// ************************************** Text Theme **************************************

TextTheme _getTextTheme(ColorScheme colorScheme) {
  const headlineColor = _light1;
  const headlineWeight = FontWeight.w800;
  const headlineHeight = 1.2;

  const titleColor = _light1;
  const titleWeight = FontWeight.w500;
  const titleHeight = 1.2;

  const bodyColor = _light2;
  const bodyWeight = FontWeight.normal;
  const bodyHeight = 1.5;

  const labelColor = titleColor;

  const textTheme = TextTheme(
    // Headline
    headlineLarge: TextStyle(
      fontSize: 24,
      
      height: headlineHeight,
      color: headlineColor,
      fontWeight: headlineWeight,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      
      height: headlineHeight,
      color: headlineColor,
      fontWeight: headlineWeight,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      
      height: headlineHeight,
      color: headlineColor,
      fontWeight: headlineWeight,
    ),

    // Title
    titleLarge: TextStyle(
      fontSize: 18,
      
      height: titleHeight,
      color: titleColor,
      fontWeight: titleWeight,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      
      height: titleHeight,
      color: titleColor,
      fontWeight: titleWeight,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      
      height: titleHeight,
      color: titleColor,
      fontWeight: titleWeight,
    ),

    // Body
    bodyLarge: TextStyle(
      fontSize: 16,
      
      height: bodyHeight,
      color: bodyColor,
      fontWeight: bodyWeight,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      
      height: bodyHeight,
      color: bodyColor,
      fontWeight: bodyWeight,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      
      height: bodyHeight,
      color: bodyColor,
      fontWeight: bodyWeight,
    ),

    // Label
    labelLarge: TextStyle(
      fontSize: 14,
      
      height: bodyHeight,
      color: labelColor,
      fontWeight: bodyWeight,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      
      height: bodyHeight,
      color: labelColor,
      fontWeight: bodyWeight,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      
      height: bodyHeight,
      color: labelColor,
      fontWeight: bodyWeight,
    ),
  );

  return textTheme;
}

/// ************************************** Common Styles **************************************

final _buttonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(16),
);
const _buttonPadding = EdgeInsets.symmetric(
  horizontal: 24,
  // vertical: 20,
);
