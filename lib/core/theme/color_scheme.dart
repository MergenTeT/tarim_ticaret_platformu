import 'package:flutter/material.dart';

class AppColorScheme {
  static const Color _primaryColor = Color(0xFF2E7D32); // Koyu yeşil
  static const Color _secondaryColor = Color(0xFF66BB6A); // Açık yeşil
  static const Color _tertiaryColor = Color(0xFFFFA000); // Turuncu
  static const Color _errorColor = Color(0xFFD32F2F); // Kırmızı

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _primaryColor,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFB9F6CA),
    onPrimaryContainer: Color(0xFF002204),
    secondary: _secondaryColor,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE8F5E9),
    onSecondaryContainer: Color(0xFF002204),
    tertiary: _tertiaryColor,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFE0B2),
    onTertiaryContainer: Color(0xFF1B1000),
    error: _errorColor,
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    background: Colors.white,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    outline: Color(0xFF79747E),
    surfaceVariant: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),
  );
} 