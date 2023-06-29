import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color backgroundColor2 = Color(0xFFfbfbfb);
  static const Color boxFillColor = Color(0xFFF9F9F9);
  static const Color errorColor = Color.fromARGB(255, 239, 59, 43);
  static const Color blackColor = Color.fromRGBO(255, 255, 255, 255);
  static const Color blueLight = Color.fromARGB(255, 132, 199, 253);
  static const LinearGradient gradient2 = LinearGradient(colors: [
    Color.fromARGB(255, 221, 255, 248),
    Color.fromARGB(255, 222, 251, 255),
    Color.fromARGB(255, 237, 253, 250),
  ], stops: [
    0.01,
    0.4167,
    1.0
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
}
