import 'package:flutter/material.dart';
import 'package:xstock/constants/asset_paths.dart';


/// headline large 24 800
/// headline large 20 800
/// headline large 18 800

/// title large 18 500
/// title medium 16 500
/// title small 14 500

/// body large 16 normal
/// body medium 14 normal
/// body small 12 normal

final lightTheme = _getTheme();

const _primary = Color(0xFF00D8FA);
const _onPrimary = Color(0xFF252934);
const _onSecondary = Color(0xFF8A8787);
const _secondary = Color(0xFF1631C2);

const _background = Color(0xFFFFFFFF);
const _onPrimaryContainer = Color(0xFFfef9f3);
const _dark1 = Colors.black;
const _onBackground = Color(0xFFEBEBEB);
const _dark2 = Colors.black87;
const _divider = Color(0xFFD9D9D9);
const _disabled = Colors.grey;

const _red = Colors.red;
const _textColor = Color(0xFF9B9B9B);

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
    brightness: Brightness.light,
    splashFactory: InkSplash.splashFactory,
    // set colors
    colorScheme: colorScheme,
    textTheme: textTheme,
    primaryTextTheme: primaryTextTheme,
    scaffoldBackgroundColor: colorScheme.background,
    disabledColor: _disabled,

    /// ************************************** BottomNavigationBar **************************************
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _primary,
      unselectedItemColor: _background,
      selectedIconTheme: IconThemeData(color: _primary),
      selectedLabelStyle: TextStyle(color: _primary, fontSize: 12),
      unselectedLabelStyle: TextStyle(color: _background, fontSize: 12),
    ),

    /// ************************************** AppBarTheme **************************************
    appBarTheme: const AppBarTheme(
      backgroundColor: _background,
      elevation: 1,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: _onPrimaryContainer,
      ),
    ),

    /// ************************************** InputDecoration **************************************
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(color: Color(0xFFB71C1C)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: const BorderSide(
          color:_divider,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide:  const BorderSide(
          color: _divider,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: const BorderSide(
          color: _dark2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: const BorderSide(
          color: Color(0xFFB71C1C),
          width: 1.0,
        ),
      ),
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      hintStyle: TextStyle(
        color: _onSecondary.withOpacity(.8),
        fontSize: 12,
        fontWeight: FontWeight.w300,
      ),
      labelStyle: const TextStyle(
        color: Colors.black38,
        fontWeight: FontWeight.normal,
      ),
    ),

    /// ************************************** DialogTheme **************************************
    dialogTheme: DialogTheme(
      backgroundColor: colorScheme.background,
      surfaceTintColor: colorScheme.background,

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
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        textStyle: buttonTextStyle,
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
      backgroundColor: _dark1,

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
      backgroundColor: _background,
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
  brightness: Brightness.light,
  // Primary
  primary: _primary,
  onPrimary: _onPrimary,
  primaryContainer: _primary.withOpacity(0.2),
  onPrimaryContainer: _onPrimaryContainer,
  // Secondary
  secondary: _secondary,
  onSecondary: _onSecondary,
  secondaryContainer: _secondary.withOpacity(0.2),
  onSecondaryContainer: _dark1,
  // Error
  error: _red,
  onError: _onPrimaryContainer,
  // Background
  background: _background,
  onBackground: _onBackground,
  // Surface
  surface: _onPrimaryContainer,
  onSurface: _dark1,
  // Outline
  outline: _divider,
);

/// ************************************** Text Theme **************************************

TextTheme _getTextTheme(ColorScheme colorScheme) {
  const headlineColor = _background;
  const headlineWeight = FontWeight.w600;
  const headlineHeight = 1.2;

  const titleColor = _background;
  const titleWeight = FontWeight.w500;
  const titleHeight = 1.2;

  const bodyColor = _background;
  const bodyWeight = FontWeight.normal;
  const bodyHeight = 1.5;

  const labelColor = titleColor;

  const textTheme = TextTheme(
    // Headline
    headlineLarge: TextStyle(
      fontSize: 24,
      fontFamily: AssetPaths.latoFont,
      height: headlineHeight,
      color: headlineColor,
      fontWeight: headlineWeight,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      height: headlineHeight,
      color: headlineColor,
      fontFamily: AssetPaths.latoFont,
      fontWeight: headlineWeight,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontFamily: AssetPaths.latoFont,
      height: headlineHeight,
      color: headlineColor,
      fontWeight: headlineWeight,
    ),

    // Title
    titleLarge: TextStyle(
      fontSize: 18,
      fontFamily: AssetPaths.latoFont,
      height: titleHeight,
      color: titleColor,
      fontWeight: titleWeight,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontFamily: AssetPaths.latoFont,
      height: titleHeight,
      color: titleColor,
      fontWeight: titleWeight,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontFamily: AssetPaths.latoFont,
      height: titleHeight,
      color: titleColor,
      fontWeight: titleWeight,
    ),

    // Body
    bodyLarge: TextStyle(
      fontSize: 16,
      fontFamily: AssetPaths.latoFont,
      height: bodyHeight,
      color: bodyColor,
      fontWeight: bodyWeight,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontFamily: AssetPaths.latoFont,
      height: bodyHeight,
      color: bodyColor,
      fontWeight: bodyWeight,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontFamily: AssetPaths.latoFont,
      height: bodyHeight,
      color: bodyColor,
      fontWeight: bodyWeight,
    ),

    // Label
    labelLarge: TextStyle(
      fontSize: 16,
      fontFamily: AssetPaths.latoFont,
      height: bodyHeight,
      color: labelColor,
      fontWeight: bodyWeight,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontFamily: AssetPaths.latoFont,
      height: bodyHeight,
      color: labelColor,
      fontWeight: bodyWeight,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontFamily: AssetPaths.latoFont,
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
