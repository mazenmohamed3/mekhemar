import 'package:flutter/material.dart';

class SizeConfig {
  static const double mobile = 550;
  static const double tablet = 600;
  static const double desktop = 1100;
  static late double width, height;

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= SizeConfig.tablet;
  }
}

