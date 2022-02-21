import 'package:flutter/material.dart';


import './energy_flow_icon/energy_flows_icon.dart';

import 'dart:math' as math;

import 'rail/inner_rail.dart';
import 'rail/outer_rail.dart';

part 'utils/utils.dart';
part 'constants/constants.dart';

class EnergyFlows extends StatelessWidget {
  const EnergyFlows({Key? key, this.pvPower, this.batPower, this.gridPower})
      : super(key: key);

  final double? pvPower, batPower, gridPower;

  @override
  Widget build(BuildContext context) {
    double canvasSize = MediaQuery.of(context).size.shortestSide;
    return SizedBox(
      width: canvasSize,
      height: canvasSize,
      child: Stack(
        children: [
          _railGroup(),
          _iconGroup(context),
        ],
      ),
    );
  }

  Stack _railGroup() {
    return Stack(
      children: const [
        OuterRail(
          startAngle: math.pi / 6,
          startColor: Colors.red,
          endColor: Colors.blue,
          reverse: true,
        ),
        OuterRail(
            startAngle: math.pi / 6 + 2 * math.pi / 3,
            startColor: Colors.blue,
            endColor: Colors.yellow,
            reverse: true),
        OuterRail(
          startAngle: math.pi / 6 + 4 * math.pi / 3,
          startColor: Colors.yellow,
          endColor: Colors.red,
        ),
        InnerRail(
            offsetDistanceRatio: 3 / 4,
            offsetDirection: 2 * math.pi / 3 + math.pi / 6,
            startColor: Colors.green,
            endColor: Colors.blue),
        InnerRail(
          offsetDistanceRatio: 3 / 4,
          offsetDirection: 2 * math.pi * 2 / 3 + math.pi / 6,
          startColor: Colors.green,
          endColor: Colors.yellow,
        ),
        InnerRail(
            offsetDistanceRatio: 3 / 4,
            offsetDirection: 2 * math.pi + math.pi / 6,
            startColor: Colors.green,
            endColor: Colors.red),
      ],
    );
  }

  Stack _iconGroup(context) {
    Size size = MediaQuery.of(context).size;
    bool pvStatus, batStatus, gridStatus, loadStatus;
    
    return Stack(children: [
      for (EnergyFlowsIconModel icon in ICON_DATA)
        Positioned(
            left: icon.offset(size).dx,
            top: icon.offset(size).dy,
            child: EnergyFlowsIcon(icon))
    ]);
  }
}

const List<EnergyFlowsIconModel> ICON_DATA = [
  EnergyFlowsIconModel(
    name: "load",
    color: Colors.green,
    offsetDistanceRatio: 0,
    offsetDirection: 0,
  ),
  EnergyFlowsIconModel(
      name: "battery",
      color: Colors.blue,
      offsetDistanceRatio: 3 / 4,
      offsetDirection: 2 * math.pi / 3 + math.pi / 6),
  EnergyFlowsIconModel(
      name: "solar",
      color: Colors.yellow,
      offsetDistanceRatio: 3 / 4,
      offsetDirection: 2 * math.pi * 2 / 3 + math.pi / 6),
  EnergyFlowsIconModel(
      name: "grid",
      color: Colors.red,
      offsetDistanceRatio: 3 / 4,
      offsetDirection: 2 * math.pi + math.pi / 6)
];
