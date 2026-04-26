import 'package:flutter/material.dart';

class BelajarInfoBoxData {
  const BelajarInfoBoxData({
    required this.title,
    required this.message,
    this.icon = Icons.lightbulb_rounded,
  });

  final String title;
  final String message;
  final IconData icon;
}
