import 'package:flutter/material.dart';

class AppColors {
  static const Color lightOrange = Color(0xFFF8A95A);
  static const Color darkPink = Color(0xFFEC3666);
  static const Color lightOrangeButton = Color(0xFFFEA401);
  static const Color darkOrangeButton = Color(0xFFF87D0A);
  static const Color lightPinkButton = Color(0xFFFCB3A8);
  static const Color mediumPinkButton = Color(0xFFFD7991);
  static const Color lightGreenButton = Color(0xFF4ADE80);
  static const Color mediumGreenButton = Color(0xFF22C55E);
  static const Color yellowIcon = Color(0xFFF9E39B);
  static const Color mediumRedButton = Color(0xFFB22222);
  static const Color darkRedButton = Color(0xFF7B1A1A);

  static const Color white10 = Color.fromRGBO(255, 255, 255, 0.1);
  static const Color white20 = Color.fromRGBO(255, 255, 255, 0.2);
  static const Color white40 = Color.fromRGBO(255, 255, 255, 0.4);
  static const Color white80 = Color.fromRGBO(255, 255, 255, 0.8);

  static const Color black20 = Color.fromRGBO(0, 0, 0, 0.2);
  static const Color black25 = Color.fromRGBO(0, 0, 0, 0.25);
  static const Color black40 = Color.fromRGBO(0, 0, 0, 0.4);
  static const Color black80 = Color.fromRGBO(0, 0, 0, 0.8);

  static const Color darkPink20 = Color.fromRGBO(236, 54, 102, 0.2);
  static const Color green40 = Color.fromRGBO(0, 255, 17, 0.4);

  static final Color lightOrangeButton20 = lightOrangeButton.withAlpha(
    (0.2 * 255).round(),
  );
  static final Color darkOrangeButton20 = darkOrangeButton.withAlpha(
    (0.2 * 255).round(),
  );
}
