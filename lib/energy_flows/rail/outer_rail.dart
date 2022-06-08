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
  late Animation<double> opacityAnimation;
  late Animation<Color?> colorAnimation;
  late Animation<double> glowScaleAnimation;

  late AnimationController rotationController;
  late AnimationController opacityController;
  late AnimationController colorController;
  late AnimationController glowScaleController;

  late Tween<double> _rotationTween;
  late Tween<double> _opacityTween;
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

    opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _setAnimation();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant OuterRail oldWidget) {
    if (widget.isActive) {
      opacityController.forward();
    } else {
      opacityController.reverse();
    }
    rotationController.animateTo(1).then((value) => {_setAnimation()});

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

    _opacityTween = Tween(begin: 0, end: 1);

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

    rotationController.forward();

    opacityAnimation = _opacityTween.animate(opacityController);

    glowScaleAnimation = _glowScaleTween
        .animate(glowScaleController..value = glowScaleController.value)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          glowScaleController.repeat(reverse: true);
        } else if (status == AnimationStatus.dismissed) {
          glowScaleController.forward();
        }
      });

    glowScaleController.forward();

    colorAnimation = _colorTween.animate((colorController
          ..value = colorController.value)
        .drive(CurveTween(curve: Curves.easeInOutExpo)))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          colorController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          colorController.forward();
        }
      });

    colorController.forward();
  }

  @override
  void dispose() {
    rotationController.dispose();
    colorController.dispose();
    glowScaleController.dispose();
    opacityController.dispose();
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
          color: colorAnimation.value?.withOpacity(opacityAnimation.value),
          glowScale: glowScaleAnimation.value,
          isActive: widget.isActive,
          appearance: widget.appearance,
        )));
  }
}
