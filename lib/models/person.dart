import 'package:flutter/material.dart';

class Person {
  final String id;
  String name;
  Color color;

  Person({
    required this.id,
    required this.name,
    required this.color,
  });

  static const List<Color> palette = [
    Color(0xFF00897B), // Teal
    Color(0xFFE65100), // Deep Orange
    Color(0xFF3949AB), // Indigo
    Color(0xFFD81B60), // Pink
    Color(0xFF6D4C41), // Brown
    Color(0xFF5E35B1), // Deep Purple
    Color(0xFF00ACC1), // Cyan
    Color(0xFF43A047), // Green
    Color(0xFFFB8C00), // Amber / Orange
    Color(0xFF546E7A), // Blue Grey
  ];

  static Color getColorForIndex(int index) {
    return palette[index % palette.length];
  }
}
