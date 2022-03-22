import 'package:flutter/material.dart';
import 'package:flutter_energy_flows/energy_flows/model/energy_flow_model.dart';

import './energy_flow_icon/energy_flows_icon.dart';

import 'dart:math' as math;

import 'rail/inner_rail.dart';
import 'rail/outer_rail.dart';

part 'utils/utils.dart';
part 'constants/constants.dart';

class EnergyFlows extends StatefulWidget {
  const EnergyFlows({Key? key, required this.model, this.size})
      : super(key: key);
  final Size? size;

  final EnergyFlowModel model;

  @override
  State<EnergyFlows> createState() => _EnergyFlowsState();
}

class _EnergyFlowsState extends State<EnergyFlows> {
  @override
  Widget build(BuildContext context) {
    double canvasSize =
        widget.size?.shortestSide ?? MediaQuery.of(context).size.shortestSide;
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
          startColor: loadColor,
          endColor: pvColor,
        ),

        OuterRail(
          startAngle: math.pi / 6 + 2 * math.pi / 3,
          startColor: batColor,
          endColor: pvColor,
          reverse: true,
          isActive: widget.model.pvToBat.isPositive,
        ),

        OuterRail(
          startAngle: math.pi / 6,
          startColor: gridColor,
          endColor: batColor,
          reverse: true,
          isActive: widget.model.batToGrid.isPositive,
        ),
        OuterRail(
          startAngle: math.pi / 6,
          startColor: gridColor,
          endColor: batColor,
          isActive: widget.model.gridToBat.isPositive,
        ),

        OuterRail(
          startAngle: math.pi / 6 + 4 * math.pi / 3,
          startColor: pvColor,
          endColor: gridColor,
          isActive: widget.model.pvToGrid.isPositive,
        ),
        InnerRail(
          offsetDistanceRatio: 3 / 4,
          offsetDirection: 2 * math.pi / 3 + math.pi / 6,
          isActive: widget.model.batToLoad.isPositive,
          startColor: loadColor,
          endColor: batColor,
        ),

        InnerRail(
          offsetDistanceRatio: 3 / 4,
          offsetDirection: 2 * math.pi + math.pi / 6,
          isActive: widget.model.gridToLoad.isPositive,
          startColor: loadColor,
          endColor: gridColor,
        ),
      ],
    );
  }

  Stack _iconGroup(context) {
    Size size =widget.size?? MediaQuery.of(context).size;

    return Stack(children: [
      for (int i = 0; i < iconModels.length; i++) ...[
        Positioned(
          left: iconModels[i].offset(size).dx,
          top: iconModels[i].offset(size).dy,
          child: EnergyFlowsIcon(
            iconModels[i],
            widget.model.powerStates[i],
            size,
            onTapDown: widget.model.onTaps[i],
            themeMode: widget.model.themeMode,
          ),
        ),
        Positioned(
            left: iconModels[i].offset(size).dx,
            top: iconModels[i].offset(size).dy,
            child: IgnorePointer(
              child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  width: size.shortestSide / 5,
                  height: size.shortestSide / 5,
                  child: Column(
                    children: [
                      SizedBox(
                          width: size.shortestSide / 7.5,
                          height:
                              size.shortestSide / 7.5,
                          child: widget.model.icons[i]),
                      Center(child: Text(widget.model.powerValues[i], style: TextStyle(fontSize: size.shortestSide / 27.5),)),
                    ],
                  )),
            )),
      ]
    ]);
  }
}
