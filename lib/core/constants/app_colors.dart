import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Dark theme (EAM glassmorphism) ────────────────────────────────────────
  static const Color darkBg = Color(0xFF080A11);        // --app-bg dark
  static const Color darkSurface = Color(0xFF0E121F);   // --app-surface dark base
  static const Color darkGlass = Color(0x120E121F);     // translucent glass overlay
  static const Color darkBorder = Color(0x2E7D97C7);    // rgba(125,151,199,0.18)
  static const Color accent = Color(0xFF50C8FF);         // --app-accent dark (cyan)
  static const Color darkBodyText = Color(0xFFEFF3FF);  // --app-body-color dark
  static const Color darkHeading = Color(0xFFF7F9FF);   // --app-heading-color dark
  static const Color darkMuted = Color(0xB3E5ECFF);     // --app-text-muted dark

  // ── Light theme ──────────────────────────────────────────────────────────
  static const Color lightBg = Color(0xFFF4F7FF);       // --app-bg light
  static const Color lightSurface = Color(0xFFFFFFFF);  // --app-surface light
  static const Color lightBorder = Color(0x296577A2);   // rgba(101,119,162,0.16)
  static const Color accentLight = Color(0xFF173EAC);   // --app-accent light (blue)
  static const Color lightBodyText = Color(0xFF4F607F); // --app-body-color light
  static const Color lightHeading = Color(0xFF253654);  // --app-heading-color light
  static const Color lightMuted = Color(0xD1364463);    // --app-text-muted light

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF4FB84E);
  static const Color warning = Color(0xFFF58345);
  static const Color danger = Color(0xFFFF6B7A);
  static const Color info = Color(0xFF7FD9FF);
  static const Color like = Color(0xFFFF4081);

  // ── Nav bar ──────────────────────────────────────────────────────────────
  static const Color navBarDark = Color(0xFF0D1020);
}
