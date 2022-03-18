part of '../energy_flows_icon.dart';

class EnergyFlowsIconModel {
  final String name;
  final Color color;
  final void Function()? onTap;

  /// How far the icon is located from the center of of the canvas,
  /// actual offset distance subjected to device size.
  ///
  /// For example, if the [offsetDistanceRatio] is set as 1/3
  /// The icon will located 1/3 screen width/height far from the center,
  /// depending on width or height is smaller.
  final double offsetDistanceRatio;

  /// The angle of icon offset from the center, measured in radians.
  /// Angle starts from 0 radian on the
  /// right side and have a range of 2 * PI radians
  final double offsetDirection;

  const EnergyFlowsIconModel(
      {required this.name,
      required this.color,
       this.onTap,
      required this.offsetDistanceRatio,
      required this.offsetDirection});

  Offset offset(Size size) {
    double shortestSide = size.shortestSide;
    double dx = (shortestSide +
            math.cos(offsetDirection) * shortestSide * offsetDistanceRatio -
            shortestSide / 5) /
        2;
    double dy = (shortestSide +
            math.sin(offsetDirection) * shortestSide * offsetDistanceRatio -
            shortestSide / 5) /
        2;
    return Offset(dx, dy);
  }
}
