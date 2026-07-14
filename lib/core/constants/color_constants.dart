import 'package:flutter/material.dart';

/// Centralized color palette — HirePro uses a light, pink-forward theme.
/// Never hardcode Color(0x...) outside this file; extend here instead.
class AppColor {
  AppColor._();

  static const Color white                            = Colors.white;
  static const Color black                            = Colors.black;

  // ---------------------------------------------------------------------
  // Base / Background
  // ---------------------------------------------------------------------
  static const Color background                       = Color(0xFFFFF8FA); // near-white, warm pink tint
  static const Color surface                          = Color(0xFFFFFFFF); // cards, sheets
  static const Color surfaceElevated                  = Color(0xFFFFF1F5); // raised surfaces, hover states

  // ---------------------------------------------------------------------
  // Primary — Pink family (brand identity)
  // ---------------------------------------------------------------------
  static const Color primary                          = Color(0xFFE8557C); // core brand pink
  static const Color primaryLight                     = Color(0xFFFCA6C1); // hover/lighter states
  static const Color primaryLighter                   = Color(0xFFFFD9E4); // badges, chip backgrounds
  static const Color primaryDark                      = Color(0xFFC13A5F); // pressed states, emphasis text
  static const Color primaryContainer                 = Color(0xFFFFE6ED); // subtle fills behind primary content

  // ---------------------------------------------------------------------
  // Secondary — Navy (from your design.md — grounds the pink)
  // ---------------------------------------------------------------------
  static const Color secondary                        = Color(0xFF1B2138);
  static const Color secondaryLight                   = Color(0xFF3B4160);
  static const Color secondaryMuted                   = Color(0xFF8A8FA3); // secondary text, icons

  // ---------------------------------------------------------------------
  // Accent families (candidate/job/tertiary cards — per design.md)
  // ---------------------------------------------------------------------
  static const Color accentBlue                       = Color(0xFFAFCBFF); // job cards
  static const Color accentBlueLight                  = Color(0xFFE3EDFF);
  static const Color accentPink                       = Color(0xFFFFB8CE); // candidate cards
  static const Color accentPinkLight                  = Color(0xFFFFE6ED);
  static const Color accentPeach                      = Color(0xFFFFCBA6); // tertiary / alerts
  static const Color accentPeachLight                 = Color(0xFFFFEEE0);

  // ---------------------------------------------------------------------
  // Semantic — Status
  // ---------------------------------------------------------------------
  static const Color success                          = Color(0xFF4CAF7D);
  static const Color successLight                     = Color(0xFFDFF5EA);
  static const Color warning                          = Color(0xFFE8A23D);
  static const Color warningLight                     = Color(0xFFFCEED9);
  static const Color error                            = Color(0xFFE0526B);
  static const Color errorLight                       = Color(0xFFFCE4E8);
  static const Color info                             = Color(0xFF4C8FE8);
  static const Color infoLight                        = Color(0xFFE2EEFC);

  // ---------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------
  static const Color textPrimary                      = Color(0xFF1B2138); // matches secondary navy
  static const Color textSecondary                    = Color(0xFF6B7085);
  static const Color textTertiary                     = Color(0xFF9CA0B0);
  static const Color textOnPrimary                    = Color(0xFFFFFFFF); // text on pink buttons
  static const Color textDisabled                     = Color(0xFFC5C8D3);

  // ---------------------------------------------------------------------
  // Borders / Dividers
  // ---------------------------------------------------------------------
  static const Color border                           = Color(0xFFF0DDE3);
  static const Color divider                          = Color(0xFFF5EBEE);

  // ---------------------------------------------------------------------
  // HireableSignal fit-score gradient (low → high match)
  // ---------------------------------------------------------------------
  static const Color scoreLow                         = Color(0xFFE0526B);
  static const Color scoreMid                         = Color(0xFFE8A23D);
  static const Color scoreHigh                        = Color(0xFF4CAF7D);

  // ---------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  // ---------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------

  /// Interpolates a score color (0.0–1.0) for HireableSignal cards.
  static Color scoreColor(double score) {
    if (score < 0.5) {
      return Color.lerp(scoreLow, scoreMid, score / 0.5)!;
    }
    return Color.lerp(scoreMid, scoreHigh, (score - 0.5) / 0.5)!;
  }
}
