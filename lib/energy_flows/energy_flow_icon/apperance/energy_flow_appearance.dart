import 'package:flutter/material.dart';

const Color activeRailColorLight = Color(0xffa2a3a3);
const Color inactiveRailColorLight = Color(0xffe3e2e3);
const Color iconColorLight = Color(0xffffffff);

const Color activeRailColorDark = Color(0xff444444);
const Color inactiveRailColorDark = Color(0xff222222);
const Color iconColorDark = Color(0xff000000);

class EnergyFlowAppearance {
  final Color activeRailColor;
  final Color inactiveRailColor;
  final Color iconColor;

  const EnergyFlowAppearance(
      {this.activeRailColor = activeRailColorLight,
      this.inactiveRailColor = inactiveRailColorLight,
      this.iconColor = iconColorLight});

  static const EnergyFlowAppearance light = EnergyFlowAppearance(
      activeRailColor: activeRailColorLight,
      inactiveRailColor: inactiveRailColorLight,
      iconColor: iconColorLight);

  static const EnergyFlowAppearance dark = EnergyFlowAppearance(
      activeRailColor: activeRailColorDark,
      inactiveRailColor: inactiveRailColorDark,
      iconColor: iconColorDark);

  EnergyFlowAppearance copyWith(
     { Color? activeRailColor, Color? inactiveRailColor, Color? iconColor}) {
    return EnergyFlowAppearance(
        activeRailColor: activeRailColor ?? this.activeRailColor,
        inactiveRailColor: inactiveRailColor ?? this.activeRailColor,
        iconColor: iconColor ?? this.iconColor);
  }
}
