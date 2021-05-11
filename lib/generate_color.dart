import 'package:flutter/material.dart';
import 'package:you_and_me/resources/colors.dart';
import 'package:you_and_me/resources/enum.dart';

class GenerateColors {
  final ThemeType themeColorData;

  GenerateColors(this.themeColorData);

  getColor(String colorType) {
    if (themeColorData == ThemeType.THEME_PINK) {
      return pinkColor[colorType];
    }
    if (themeColorData == ThemeType.THEME_BLUE) {
      return blueColor[colorType];
    }
    if (themeColorData == ThemeType.THEME_GREEN) {
      return greenColor[colorType];
    }
    if (themeColorData == ThemeType.THEME_PURPLE) {
      return purpleColor[colorType];
    }
  }

}
