import 'package:flutter/material.dart';

extension BuildContextHelper on BuildContext {
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get largeFont => (screenWidth * 0.05).clamp(16.0, 22.0);

  double get mediumFont => (screenWidth * 0.041).clamp(14.0, 18.0);

  double get smallFont => (screenWidth * 0.036).clamp(12.0, 16.0);

  double get iconSize => (screenWidth * 0.061).clamp(20.0, 28.0);
}
