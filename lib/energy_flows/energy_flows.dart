import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_energy_flows/energy_flows/model/energy_flow_model.dart';

import './energy_flow_icon/energy_flows_icon.dart';

import 'dart:math' as math;

import 'rail/inner_rail.dart';
import 'rail/outer_rail.dart';

part 'utils/utils.dart';
part 'constants/constants.dart';

class EnergyFlows extends StatefulWidget {
  const EnergyFlows({Key? key, required this.model}) : super(key: key);

  final EnergyFlowModel model;

  @override
  State<EnergyFlows> createState() => _EnergyFlowsState();
}

class _EnergyFlowsState extends State<EnergyFlows> {
  @override
  Widget build(BuildContext context) {
    double canvasSize = MediaQuery.of(context).size.shortestSide;
    return SizedBox(
      width: canvasSize,
      height: canvasSize,
      child: Stack(
        children: [
          _railGroup(context),
          _iconGroup(context),
        ],
      ),
    );
  }

  Stack _railGroup(context) {
    if (widget.model.isValid) {}
    return Stack(
      children: [
        /// Solar To Home
        InnerRail(
          offsetDistanceRatio: 3 / 4,
          offsetDirection: 2 * math.pi * 2 / 3 + math.pi / 6,
          isActive: widget.model.pvToLoad.isPositive,
          startColor: const Color(0xff4fbba9),
          endColor: const Color(0xfff8dd6c),
        ),

        OuterRail(
          startAngle: math.pi / 6 + 2 * math.pi / 3,
          startColor: const Color(0XFF233C7B),
          endColor: const Color(0xFFF8DD6C),
          reverse: true,
          isActive: widget.model.pvToBat.isPositive,
        ),

        OuterRail(
          startAngle: math.pi / 6,
          startColor: Color(0XFFEB5B56),
          endColor: Color(0XFF233C7B),
          reverse: true,
          isActive: widget.model.batToGrid.isPositive,
        ),
        OuterRail(
          startAngle: math.pi / 6,
          startColor: Color(0XFFEB5B56),
          endColor: Color(0XFF233C7B),
          isActive: widget.model.gridToBat.isPositive,
        ),

        OuterRail(
          startAngle: math.pi / 6 + 4 * math.pi / 3,
          startColor: Color(0xfff8DD6C),
          endColor: Color(0xffeB5B56),
          isActive: widget.model.pvToGrid.isPositive,
        ),
        InnerRail(
          offsetDistanceRatio: 3 / 4,
          offsetDirection: 2 * math.pi / 3 + math.pi / 6,
          isActive: widget.model.batToLoad.isPositive,
          startColor: Color(0xff4fbba9),
          endColor: Color(0xff233C7B),
        ),

        InnerRail(
          offsetDistanceRatio: 3 / 4,
          offsetDirection: 2 * math.pi + math.pi / 6,
          isActive: widget.model.gridToLoad.isPositive,
          startColor: Color(0xff4fbba9),
          endColor: Color(0xffeB5B56),
        ),
      ],
    );
  }

  Stack _iconGroup(context) {
    Size size = MediaQuery.of(context).size;

    return Stack(children: [
      for (int i = 0; i < iconModels.length; i++) ...[
        Positioned(
          left: iconModels[i].offset(size).dx,
          top: iconModels[i].offset(size).dy,
          child: EnergyFlowsIcon(
            iconModels[i],
            widget.model.powerStates[i],
            onTap: widget.model.onTaps[i],
            themeMode: widget.model.themeMode,
          ),
        ),
        Positioned(
            left: iconModels[i].offset(size).dx,
            top: iconModels[i].offset(size).dy,
            child: IgnorePointer(
              child: SizedBox(
                  width: MediaQuery.of(context).size.shortestSide / 5,
                  height: MediaQuery.of(context).size.shortestSide / 5,
                  child: Center(child: Text(widget.model.powerValues[i]))),
            )),
      ]
    ]);
  }
}
