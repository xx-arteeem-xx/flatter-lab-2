import 'package:flutter/material.dart';

class InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final String? url;

  const InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.url,
  });
}
