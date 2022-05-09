import 'package:flutter/material.dart';
import 'package:flutter_energy_flows/energy_flows/energy_flow_icon/apperance/energy_flow_appearance.dart';

import 'dart:math' as math;

import '../energy_flows.dart';

part './painter/outer_rail_painter.dart';

class OuterRail extends StatefulWidget {
  final double startAngle, sweepAngle;
  final Color startColor, endColor;
  final bool reverse, isActive;
  final EnergyFlowAppearance appearance;
  const OuterRail(
      {Key? key,
      required this.appearance,
      required this.startAngle,
      this.sweepAngle = 2 * math.pi / 3,
      required this.startColor,
      required this.endColor,
      required this.isActive,
      this.reverse = false})
      : super(key: key);

  @override
  State<OuterRail> createState() => _OuterRailState();
}

class _OuterRailState extends State<OuterRail> with TickerProviderStateMixin {
  late Animation<double> rotationAnimation;
  late Animation<Color?> colorAnimation;
  late Animation<double> glowScaleAnimation;

  late AnimationController rotationController;
  late AnimationController colorController;
  late AnimationController glowScaleController;

  late Tween<double> _rotationTween;
  late ColorTween _colorTween;
  late Tween<double> _glowScaleTween;

  @override
  void initState() {
    rotationController = AnimationController(
        vsync: this, duration: ENERGY_BLOB_GLOW_COLOR_DURATION);

    glowScaleController = AnimationController(
        vsync: this, duration: ENERGY_BLOB_GLOW_SCALE_DURATION);

    colorController = AnimationController(
        vsync: this, duration: ENERGY_BLOB_GLOW_COLOR_DURATION);
    _setAnimation();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant OuterRail oldWidget) {

    _setAnimation();

    super.didUpdateWidget(oldWidget);
  }

  void _setAnimation() {
    if (!widget.reverse) {
      _rotationTween = Tween(
          begin: widget.startAngle, end: widget.sweepAngle + widget.startAngle);
      _colorTween = ColorTween(begin: widget.startColor, end: widget.endColor);
    } else {
      _rotationTween = Tween(
          begin: widget.sweepAngle + widget.startAngle, end: widget.startAngle);
      _colorTween = ColorTween(begin: widget.endColor, end: widget.startColor);
    }

    _glowScaleTween = Tween(
        begin: ENERGY_BLOB_GLOW_SCALE_MIN, end: ENERGY_BLOB_GLOW_SCALE_MAX);

    

    rotationAnimation = _rotationTween.animate(rotationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rotationController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          rotationController.forward();
        }
      });

    glowScaleAnimation = _glowScaleTween.animate(glowScaleController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          glowScaleController.repeat(reverse: true);
        } else if (status == AnimationStatus.dismissed) {
          glowScaleController.forward();
        }
      });

    colorAnimation = _colorTween
        .animate(colorController.drive(CurveTween(curve: Curves.easeInOutExpo)))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          colorController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          colorController.forward();
        }
      });

    rotationController.forward();

    glowScaleController.forward();

    colorController.forward();
  }

  @override
  void dispose() {
    rotationController.dispose();
    colorController.dispose();
    glowScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(
            painter: OuterRailPainter(
          startAngle: widget.startAngle,
          sweepAngle: widget.sweepAngle,
          rotation: rotationAnimation.value,
          color: colorAnimation.value,
          glowScale: glowScaleAnimation.value,
          isActive: widget.isActive,
          appearance: widget.appearance,
        )));
  }
}
