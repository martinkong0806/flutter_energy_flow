import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_energy_flows/energy_flows/energy_flow_icon/apperance/energy_flow_appearance.dart';

import 'dart:math' as math;

import '../energy_flows.dart';

part './painter/inner_rail_painter.dart';

class InnerRail extends StatefulWidget {
  const InnerRail({
    Key? key,
    required this.offsetDistanceRatio,
    required this.offsetDirection,
    required this.isActive,
    required this.startColor,
    required this.endColor,
    required this.appearance,
    this.reverse = true,
  }) : super(key: key);

  final double offsetDistanceRatio;
  final double offsetDirection;
  final bool isActive;
  final Color startColor;
  final Color endColor;
  final bool reverse;
  final EnergyFlowAppearance appearance;

  @override
  State<InnerRail> createState() => _InnerRailState();
}

class _InnerRailState extends State<InnerRail> with TickerProviderStateMixin {
  late Animation<double> progressAnimation;
  late Animation<double> opacityAnimation;
  late Animation<Color?> colorAnimation;
  late Animation<double> glowScaleAnimation;

  late AnimationController progressController;
  late AnimationController colorController;
  late AnimationController glowScaleController;
  late AnimationController opacityController;

  late Tween<double> _progressTween;
  late Tween<double> _opacityTween;

  late ColorTween _colorTween;
  late Tween<double> _glowScaleTween;

  @override
  void initState() {
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    glowScaleController = AnimationController(
      vsync: this,
      duration: ENERGY_BLOB_GLOW_SCALE_DURATION,
    );

    colorController = AnimationController(
      vsync: this,
      duration: ENERGY_BLOB_GLOW_COLOR_DURATION,
    );

    opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _setAnimation();

    super.initState();
  }

  void _setAnimation() {
    if (!widget.reverse) {
      _progressTween = Tween(begin: 0, end: 1);
      _colorTween = ColorTween(begin: widget.startColor, end: widget.endColor);
    } else {
      _progressTween = Tween(begin: 1, end: 0);
      _colorTween = ColorTween(begin: widget.endColor, end: widget.startColor);
    }
    _opacityTween = Tween(begin: 0, end: 1);

    _glowScaleTween = Tween(
        begin: ENERGY_BLOB_GLOW_SCALE_MIN, end: ENERGY_BLOB_GLOW_SCALE_MAX);

    opacityAnimation = _opacityTween.animate(opacityController);

    progressAnimation = _progressTween
        .animate(progressController..value = progressController.value)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          progressController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          progressController.forward();
        }
      });

    progressController.forward();

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
  void didUpdateWidget(covariant InnerRail oldWidget) {
    if (widget.isActive) {
      opacityController.forward();
    } else {
      opacityController.reverse();
    }
    progressController.animateTo(1).then((value) => {_setAnimation()});
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    progressController.dispose();
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
            painter: InnerRailPainter(
                offsetDirection: widget.offsetDirection,
                offsetDistanceRatio: widget.offsetDistanceRatio,
                progress: progressAnimation.value,
                color:
                    colorAnimation.value?.withOpacity(opacityAnimation.value),
                glowScale: glowScaleAnimation.value,
                isActive: widget.isActive,
                appearance: widget.appearance)));
  }
}
