import 'package:flutter/material.dart';
import 'package:you_and_me/resources/enum.dart';

class GenerateColors {
  final ThemeType themeColorData;

  GenerateColors(this.themeColorData);

  getBgColor() {
    if (themeColorData == ThemeType.THEME_PINK) {
      return Colors.pink;
    }
    if (themeColorData == ThemeType.THEME_BLUE) {
      return Colors.blue;
    }
    if (themeColorData == ThemeType.THEME_GREEN) {
      return Colors.green;
    }
    if (themeColorData == ThemeType.THEME_PURPLE) {
      return Colors.deepPurple;
    }
  }

}
