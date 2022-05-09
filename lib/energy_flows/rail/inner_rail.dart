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
  late Animation<Color?> colorAnimation;
  late Animation<double> glowScaleAnimation;

  AnimationController? progressController;
  AnimationController? colorController;
  AnimationController? glowScaleController;

  late Tween<double> _progressTween;

  late ColorTween _colorTween;
  late Tween<double> _glowScaleTween;

  @override
  void initState() {
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

    _glowScaleTween = Tween(
        begin: ENERGY_BLOB_GLOW_SCALE_MIN, end: ENERGY_BLOB_GLOW_SCALE_MAX);

    progressController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4), value: progressController?.value);

    glowScaleController = AnimationController(
        vsync: this, duration: ENERGY_BLOB_GLOW_SCALE_DURATION, value: glowScaleController?.value);

    colorController = AnimationController(
        vsync: this, duration: ENERGY_BLOB_GLOW_COLOR_DURATION, value: colorController?.value);

    progressAnimation = _progressTween.animate(progressController!)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          progressController!.repeat();
        } else if (status == AnimationStatus.dismissed) {
          progressController!.forward();
        }
      });

    progressController!.forward();

    glowScaleAnimation = _glowScaleTween.animate(glowScaleController!)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          glowScaleController!.repeat(reverse: true);
        } else if (status == AnimationStatus.dismissed) {
          glowScaleController!.forward();
        }
      });

    glowScaleController!.forward();

    colorAnimation = _colorTween
        .animate(colorController!.drive(CurveTween(curve: Curves.easeInOutExpo)))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          colorController!.repeat();
        } else if (status == AnimationStatus.dismissed) {
          colorController!.forward();
        }
      });

    colorController!.forward();
  }

  @override
  void didUpdateWidget(covariant InnerRail oldWidget) {
    _setAnimation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    progressController?.dispose();
    colorController?.dispose();
    glowScaleController?.dispose();
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
                color: colorAnimation.value,
                glowScale: glowScaleAnimation.value,
                isActive: widget.isActive,
                appearance: widget.appearance)));
  }
}
