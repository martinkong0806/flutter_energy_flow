import 'package:flutter/material.dart';

import 'dart:math' as math;

import '../energy_flows.dart';

part 'energy_flows_icon_painter.dart';
part 'model/energy_flows_icon_model.dart';

/// The Icons that indicates all the energy sources of a battery system
class EnergyFlowsIcon extends StatefulWidget {
  final EnergyFlowsIconModel _model;
  final bool _isActive;
  final void Function()? onTap;
  final ThemeMode themeMode;

  const EnergyFlowsIcon(EnergyFlowsIconModel model, bool isActive,
      {Key? key, this.onTap, required this.themeMode})
      : _model = model,
        _isActive = isActive,
        super(key: key);

  @override
  State<EnergyFlowsIcon> createState() => _EnergyFlowsIconState();
}

class _EnergyFlowsIconState extends State<EnergyFlowsIcon>
    with TickerProviderStateMixin {
  late Animation<double> glowAnimation;
  late AnimationController controller;

  final Tween<double> glowTween =
      Tween(begin: ICON_GLOW_SIZE_MIN, end: ICON_GLOW_SIZE_MAX);

  late EnergyFlowsIconModel model;

  @override
  void initState() {
    model = widget._model;

    controller = AnimationController(vsync: this, duration: ICON_GLOW_DURTAION);
    glowAnimation = glowTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat(reverse: true);
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double canvasSize = MediaQuery.of(context).size.shortestSide / 5;
    return SizedBox(
        width: canvasSize,
        height: canvasSize,
        child: GestureDetector(
          onTap: widget.onTap,
          child: CustomPaint(
              painter: EnergyFlowsIconPaint(
            color: model.color,
            offsetDistanceRatio: model.offsetDistanceRatio,
            offsetDirection: model.offsetDirection,
            glow: glowAnimation.value,
            isActive: widget._isActive,
            themeMode: widget.themeMode,
          )),
        ));
  }
}
