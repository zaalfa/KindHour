import 'package:flutter/material.dart';

class ThemeConfig {
  static Color getPastelBackground(String timeBlock) {
    switch (timeBlock) {
      case 'morning':
        return const Color(0xFFFFFDE7); // soft yellow
      case 'noon':
        return const Color(0xFFE8F5E9); // soft green
      case 'afternoon':
        return const Color(0xFFFFF3E0); // soft orange
      case 'evening':
        return const Color(0xFFF3E5F5); // soft lavender
      case 'night':
        return const Color(0xFFE8EAF6); // soft indigo
      default:
        return const Color(0xFFFFF0F5); // fallback pink
    }
  }

  static Color getMonochromeBackground(String timeBlock) {
    switch (timeBlock) {
      case 'morning':
        return const Color(0xFFF5F5F5);
      case 'noon':
        return const Color(0xFFEEEEEE);
      case 'afternoon':
        return const Color(0xFFE0E0E0);
      case 'evening':
        return const Color(0xFF757575);
      case 'night':
        return const Color(0xFF424242);
      default:
        return const Color(0xFFBDBDBD);
    }
  }

  static Color getTextColor(String timeBlock, bool isMonochrome) {
    if (isMonochrome) {
      // dark text for light blocks, light text for dark blocks
      switch (timeBlock) {
        case 'evening':
        case 'night':
          return Colors.white;
        default:
          return Colors.black87;
      }
    }
    return Colors.black87;
  }
}
