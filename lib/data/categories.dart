// ============================================================================
// Helper / Data: Categories Configuration
// Provides available product categories along with their corresponding icons and colors.
// ============================================================================

import 'package:flutter/material.dart'; // Imports Flutter's standard Material Design library.

// A constant list containing all supported category names in the application.
const List<String> kCategories = [
  'smartphones',
  'audio',
  'clothing',
  'computers',
  'photography',
  'accessories',
  'furniture',
];

// Helper function that returns an appropriate Material Icon for a given category name.
IconData iconForCategory(String category) {
  // Switch statement inspects the category string and returns a matching icon.
  switch (category.toLowerCase()) {
    case 'smartphones':
      return Icons.phone_iphone; // Icon of a mobile phone.
    case 'audio':
      return Icons.headphones; // Icon of over-ear headphones.
    case 'clothing':
      return Icons.checkroom; // Icon of a clothes hanger.
    case 'computers':
      return Icons.laptop_mac; // Icon of a laptop computer.
    case 'photography':
      return Icons.photo_camera; // Icon of a digital camera.
    case 'accessories':
      return Icons.backpack; // Icon of a backpack.
    case 'furniture':
      return Icons.chair_outlined; // Icon of furniture/chair.
    default:
      return Icons.shopping_bag; // Fallback icon if category is unknown.
  }
}

// Helper function that returns a curated accent Color for a given category name.
Color colorForCategory(String category) {
  // Switch statement assigns distinct visual theme colors for each category.
  switch (category.toLowerCase()) {
    case 'smartphones':
      return const Color(0xFF2563EB); // Vibrant Royal Blue.
    case 'audio':
      return const Color(0xFF059669); // Emerald Green.
    case 'clothing':
      return const Color(0xFFC2410C); // Warm Orange / Terracotta.
    case 'computers':
      return const Color(0xFF7C3AED); // Deep Violet / Purple.
    case 'photography':
      return const Color(0xFF4D7C0F); // Olive Green.
    case 'accessories':
      return const Color(0xFFBE185D); // Rose Pink / Magenta.
    case 'furniture':
      return const Color(0xFFB45309); // Amber / Warm Brown.
    default:
      return const Color(0xFF475569); // Slate Grey fallback.
  }
}
