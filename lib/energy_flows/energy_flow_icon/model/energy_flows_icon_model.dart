part of '../energy_flows_icon.dart';

class EnergyFlowsIconModel {
  final String name;
  final Color color;
  final void Function(TapDownDetails details)? onTap;
  final Widget? icon;

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
      this.icon,
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

  EnergyFlowsIconModel copyWith(
      {String? name,
      Color? color,
      void Function(TapDownDetails details)? onTap,
      Widget? icon,
      double? offsetDistanceRatio,
      double? offsetDirection}) {
    return EnergyFlowsIconModel(
        name: name ?? this.name,
        color: color ?? this.color,
        onTap: onTap ?? this.onTap,
        icon: icon ?? this.icon,
        offsetDistanceRatio: offsetDistanceRatio ?? this.offsetDistanceRatio,
        offsetDirection: offsetDirection ?? this.offsetDirection);
  }

  const EnergyFlowsIconModel.solar()
      : this(
          name: "solar",
          color: pvColor,
          offsetDistanceRatio: 3 / 4,
          offsetDirection: 2 * math.pi * 2 / 3 + math.pi / 6,
        );

  const EnergyFlowsIconModel.load()
      : this(
          name: "load",
          color: loadColor,
          offsetDistanceRatio: 0,
          offsetDirection: 0,
        );

  const EnergyFlowsIconModel.battery()
      : this(
          name: "battery",
          color: batColor,
          offsetDistanceRatio: 3 / 4,
          offsetDirection: 2 * math.pi / 3 + math.pi / 6,
        );

  const EnergyFlowsIconModel.grid()
      : this(
          name: "grid",
          color: gridColor,
          offsetDistanceRatio: 3 / 4,
          offsetDirection: 2 * math.pi + math.pi / 6,
        );
  


  const EnergyFlowsIconModel.tariff()
      : this(
          name: "tariff",
          color: gridColor,
          offsetDistanceRatio: 1/2,
          offsetDirection: 2 * math.pi + math.pi / 2 ,
        );
}
