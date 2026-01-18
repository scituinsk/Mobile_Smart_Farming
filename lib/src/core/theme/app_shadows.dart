/// A utility class that provides predefined shadow effects for UI Elements.
/// This class contains static constant for shadows that can be applied to text or other widgets
/// to create visual depth and effects like fading or dissolving.

library;

import 'package:flutter/material.dart';

/// A collection of shadow effect for enchancing text and UI elements.
/// Each shadow is designed to create layered depth, such as a dissolving fade effect.
class AppShadows {
  /// A list of shadow that create a blak fading dissolfe effect.
  /// This effect layers multiple shadows with increasing blur radius and decreasing opacity
  /// to simulate a text dissolving into the background.
  ///
  /// Usage example:
  /// ```dart
  /// Text(
  ///   'Hello World',
  ///   style: TextStyle(
  ///     shadows: AppShadows.blackFade,
  ///   ),
  /// )
  /// ```
  static const List<Shadow> blackFade = [
    // First shadow: darkest and closets to the text.
    Shadow(offset: Offset(0, 0), blurRadius: 2, color: Colors.black87),
    // Second shadow: slightly more blurred.
    Shadow(offset: Offset(0, 0), blurRadius: 4, color: Colors.black54),
    // Third shadow: increasingly blurred for dissolve effect.
    Shadow(offset: Offset(0, 0), blurRadius: 8, color: Colors.black38),
    // Fourth shadow: smothest layer
    Shadow(offset: Offset(0, 0), blurRadius: 12, color: Colors.black26),
    Shadow(offset: Offset(0, 0), blurRadius: 18, color: Colors.black12),
    Shadow(offset: Offset(0, 0), blurRadius: 26, color: Colors.black),
  ];
}
