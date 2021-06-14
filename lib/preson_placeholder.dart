import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersonPlaceHolder extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final double iconSize;
  final bgColor;
  final borderColor;
  final iconColor;

//BG => 0xfffff6f5
//borderColor => 0xfffdaaa3
//iconColor => 0xffff495a
  PersonPlaceHolder(
    this.bgColor,
    this.borderColor,
    this.iconColor, {
    this.imageHeight = 200.0,
    this.imageWidth = 160.0,
    this.iconSize = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: imageWidth,
      height: imageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            12.0,
          ),
        ),
        color: bgColor, //BODY_BG_COLOR
        border: Border.all(
          color: borderColor,
        ), // ICON_COLOR_LIGHT
      ),
      child: IconButton(
        icon: FaIcon(
          FontAwesomeIcons.kissWinkHeart,
          color: iconColor,
          // PROGRESS_COLOR
          size: iconSize,
        ),
      ),
    );
  }
}
