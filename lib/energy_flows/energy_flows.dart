import 'dart:async';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_energy_flows/energy_flows/model/energy_flow_model.dart';

import './energy_flow_icon/energy_flows_icon.dart';

import 'dart:math' as math;

import 'energy_flow_icon/apperance/energy_flow_appearance.dart';
import 'rail/inner_rail.dart';
import 'rail/outer_rail.dart';

part 'utils/utils.dart';
part 'constants/constants.dart';

class EnergyFlows extends StatefulWidget {
  const EnergyFlows(
      {Key? key,
      required this.model,
      required this.items,
      this.appearance = EnergyFlowAppearance.light,
      this.size})
      : super(key: key);
  final Size? size;

  final EnergyFlowModel model;
  final EnergyFlowAppearance appearance;
  final List<EnergyFlowsIconModel> items;

  @override
  State<EnergyFlows> createState() => _EnergyFlowsState();
}

class _EnergyFlowsState extends State<EnergyFlows> {
  @override
  Widget build(BuildContext context) {
    double canvasSize =
        widget.size?.shortestSide ?? MediaQuery.of(context).size.shortestSide;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width: canvasSize,
        height: canvasSize,
        child: Stack(
          children: [
            _railGroup(context),
            _iconGroup(context, constraints),
          ],
        ),
      );
    });
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
          appearance: widget.appearance,
        ),

        OuterRail(
          startAngle: math.pi / 6 + 2 * math.pi / 3,
          startColor: widget.appearance.batteryColor ?? batColor,
          endColor: pvColor,
          reverse: true,
          isActive: widget.model.pvToBat.isPositive,
          appearance: widget.appearance,
        ),

        if (widget.model.batToGrid.isPositive)
          OuterRail(
            startAngle: math.pi / 6,
            startColor: gridColor,
            endColor: widget.appearance.batteryColor ?? batColor,
            reverse: true,
            isActive: widget.model.batToGrid.isPositive,
            appearance: widget.appearance,
          ),

        if (widget.model.gridToBat.isPositive)
          OuterRail(
            startAngle: math.pi / 6,
            startColor: gridColor,
            endColor: widget.appearance.batteryColor ?? batColor,
            isActive: widget.model.gridToBat.isPositive,
            appearance: widget.appearance,
          ),

        if (!widget.model.gridToBat.isPositive &&
            !widget.model.batToGrid.isPositive)
          OuterRail(
            startAngle: math.pi / 6,
            startColor: gridColor,
            endColor: widget.appearance.batteryColor ?? batColor,
            isActive: widget.model.gridToBat.isPositive,
            appearance: widget.appearance,
          ),

        OuterRail(
          startAngle: math.pi / 6 + 4 * math.pi / 3,
          startColor: pvColor,
          endColor: gridColor,
          isActive: widget.model.pvToGrid.isPositive,
          appearance: widget.appearance,
        ),
        InnerRail(
          offsetDistanceRatio: 3 / 4,
          offsetDirection: 2 * math.pi / 3 + math.pi / 6,
          isActive: widget.model.batToLoad.isPositive,
          startColor: loadColor,
          endColor: widget.appearance.batteryColor ?? batColor,
          appearance: widget.appearance,
        ),

        InnerRail(
          offsetDistanceRatio: 3 / 4,
          offsetDirection: 2 * math.pi + math.pi / 6,
          isActive: widget.model.gridToLoad.isPositive,
          startColor: loadColor,
          endColor: gridColor,
          appearance: widget.appearance,
        ),

        InnerRail(
          offsetDistanceRatio: 1 / 2,
          offsetDirection: 2 * math.pi + math.pi / 2,
          isActive: widget.model.pvToLoad.isPositive,
          startColor: loadColor,
          endColor: gridColor,
          appearance: widget.appearance,
        ),

        InnerRail(
          offsetDistanceRatio: 1 / 2,
          offsetDirection:  2 * math.pi / 3 + math.pi / 2,
          isActive: widget.model.pvToLoad.isPositive,
          startColor: loadColor,
          endColor: loadColor,
          appearance: widget.appearance,
        ),

        InnerRail(
          offsetDistanceRatio: 1 / 2,
          offsetDirection: 2 * math.pi * 2 / 3 + math.pi / 2,
          isActive: widget.model.pvToLoad.isPositive,
          startColor: loadColor,
          endColor: batColor,
          appearance: widget.appearance,
        ),


      
      ],
    );
  }

  Stack _iconGroup(BuildContext context, BoxConstraints constraints) {
    double s = min(constraints.maxWidth, constraints.maxHeight);
    Size size = Size(s, s);

    return Stack(children: [
      for (int i = 0; i < widget.items.length; i++) ...[
        Positioned(
          left: widget.items[i].offset(size).dx,
          top: widget.items[i].offset(size).dy,
          child: Semantics(
            label: '''
${widget.items[i].name} power : ${widget.model.powerValuesString[i]}
''',
            child: EnergyFlowsIcon(
              widget.items[i],
              widget.model.powerStates[i],
              size,
              onTapDown: widget.items[i].onTap,
              appearance: widget.appearance,
            ),
          ),
        ),
        Positioned(
            left: widget.items[i].offset(size).dx,
            top: widget.items[i].offset(size).dy,
            child: IgnorePointer(
              child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  width: size.shortestSide / 5,
                  height: size.shortestSide / 5,
                  child: Column(
                    children: [
                      SizedBox(
                          width: size.shortestSide / 7.5,
                          height: size.shortestSide / 7.5,
                          child: widget.items[i].icon),
                      Center(
                          child: PowerText(widget.model.powerValuesString[i],
                              style: (Theme.of(context).textTheme.bodyText1 ??
                                      const TextStyle(color: Colors.black))
                                  .copyWith(
                                fontSize: size.shortestSide / 27.5,
                              ),
                              isDisabled: widget.model.isDisabled,
                              displayAsUnsigned: widget.model.displayAsUnsigned,
                              displayKiloWattsAsSmallest:
                                  widget.model.displayKiloWattsAsSmallest,
                              displayPowerChangeIndicationColor: widget
                                  .model.displayPowerChangeIndicationColor)),
                    ],
                  )),
            )),
      ]
    ]);
  }
}

class PowerText extends StatefulWidget {
  const PowerText(String data,
      {Key? key,
      required this.style,
      this.isDisabled = false,
      this.displayAsUnsigned = true,
      this.displayKiloWattsAsSmallest = false,
      this.displayPowerChangeIndicationColor = true})
      : _data = data,
        super(
          key: key,
        );

  final TextStyle style;
  final bool displayAsUnsigned;
  final bool isDisabled;
  final bool displayKiloWattsAsSmallest;
  final bool displayPowerChangeIndicationColor;
  final String _data;

  @override
  State<PowerText> createState() => _PowerTextState();
}

class _PowerTextState extends State<PowerText>
    with SingleTickerProviderStateMixin {
  late String data;
  // bool _showBlink = false;
  Animation<Color?>? _animation;

  late AnimationController _controller;
  ColorTween? _colorTween;

  Timer? blinkTimer;
  @override
  void initState() {
    data = widget._data;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(reverse: true);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant PowerText oldWidget) {
    setState(() {
      if (widget.displayPowerChangeIndicationColor) {
        if (data != widget._data) {
          Color _blinkColor;
          if ((double.tryParse(widget._data) ?? 0) >
              (double.tryParse(data) ?? 0)) {
            _blinkColor = Colors.green;
          } else {
            _blinkColor = Colors.red;
          }
          _colorTween = ColorTween(begin: widget.style.color, end: _blinkColor);
          _animation = _colorTween!.animate(_controller)
            ..addListener(() {
              setState(() {});
            });

          blinkTimer?.cancel();
          blinkTimer = Timer(const Duration(seconds: 3), () {
            _animation = null;
          });
        }
      }

      data = widget._data;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget._data,
        style: widget.style.copyWith(color: _animation?.value));
  }
}
