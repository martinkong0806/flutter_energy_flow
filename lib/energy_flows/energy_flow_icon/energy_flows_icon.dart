import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_energy_flows/energy_flows/energy_flow_icon/apperance/energy_flow_appearance.dart';

import 'dart:math' as math;

import '../energy_flows.dart';

part 'energy_flows_icon_painter.dart';
part 'model/energy_flows_icon_model.dart';

/// The Icons that indicates all the energy sources of a battery system
class EnergyFlowsIcon extends StatefulWidget {
  final EnergyFlowsIconModel _model;
  final bool _isActive;
  final Size _size;
  final void Function(TapDownDetails)? onTapDown;

  final EnergyFlowAppearance appearance;

  const EnergyFlowsIcon(EnergyFlowsIconModel model, bool isActive, Size size,
      {Key? key, this.onTapDown, required this.appearance})
      : _model = model,
        _isActive = isActive,
        _size = size,
        super(key: key);

  @override
  State<EnergyFlowsIcon> createState() => _EnergyFlowsIconState();
}

class _EnergyFlowsIconState extends State<EnergyFlowsIcon>
    with TickerProviderStateMixin {
  late Animation<Color?> colorAnimation;
  late Animation<double> glowAnimation;
  late AnimationController controller;
  late AnimationController colorController;

  final Tween<double> glowTween =
      Tween(begin: ICON_GLOW_SIZE_MIN, end: ICON_GLOW_SIZE_MAX);
  late ColorTween colorTween;

  late EnergyFlowsIconModel model;

  @override
  void initState() {
    model = widget._model;

    colorTween = ColorTween(
        begin: widget.appearance.inactiveRailColor,
        end: model.name == 'battery'
            ? widget.appearance.batteryColor ?? model.color
            : model.color);

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

    colorController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    colorAnimation = colorTween.animate(colorController)
      ..addListener(() {
        setState(() {});
      });

    if (widget._isActive) {
      colorController.forward();
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant EnergyFlowsIcon oldWidget) {
    colorTween = ColorTween(
        begin: widget.appearance.inactiveRailColor,
        end: model.name == 'battery'
            ? widget.appearance.batteryColor ?? model.color
            : model.color);
    if (oldWidget._isActive != widget._isActive) {
      if (widget._isActive) {
        colorController.forward();
      } else {
        colorController.reverse();
        controller.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double canvasSize = widget._size.shortestSide / 5;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // print(constraints.minHeight);
      // double canvasSize = min(constraints.maxHeight, constraints.maxWidth)/5;
      return SizedBox(
          width: canvasSize,
          height: canvasSize,
          child: GestureDetector(
            onTapDown: widget.onTapDown,
            child: CustomPaint(
                painter: EnergyFlowsIconPaint(
              color:
                  colorAnimation.value ?? widget.appearance.inactiveRailColor,
              offsetDistanceRatio: model.offsetDistanceRatio,
              offsetDirection: model.offsetDirection,
              glow: glowAnimation.value * colorController.value,
              isActive: widget._isActive,
              appearance: widget.appearance,
            )),
          ));
    });
  }
}
