import 'dart:math';

import 'package:flutter/material.dart';

class EnergyFlowModel {
  EnergyFlowModel(
      {this.pvPower = 0,
      this.batPower = 0,
      this.gridPower = 0,
      this.loadPowerC,
      this.displayKiloWattsAsSmallest = true,
      this.displayPowerChangeIndicationColor = false,
      this.pvIcon,
      this.loadIcon,
      this.batIcon,
      this.gridIcon,
      this.onPvTap,
      this.onLoadTap,
      this.onBatTap,
      this.onGridTap,
      this.themeMode = ThemeMode.light,
      this.isDisabled = false,
      this.displayAsUnsigned = true});

  /// in Watts
  final double pvPower;
  // in Watts
  // Negative as charging, positive as discharging
  final double batPower;
  // in Watts
  // Negative as importing, positive as exporting
  final double gridPower;

  /// Custome loadPower, if load power is not specified,
  ///  the load power will be calaulated. The value is not
  /// involved in calcuation.
  final double? loadPowerC;

  final bool displayKiloWattsAsSmallest;

  final bool displayPowerChangeIndicationColor;

  final Widget? pvIcon, loadIcon, batIcon, gridIcon;

  final void Function(TapDownDetails)? onPvTap, onLoadTap, onBatTap, onGridTap;

  /// TODO, this flag is will casue bug currently, scheduled to fix.
  /// Show power values unsigned
  final bool displayAsUnsigned;

  final ThemeMode themeMode;

  final bool isDisabled;

  /// Unlogical power values may occur if the system consist more than 1 inverter
  bool get isValid => isDisabled ? false : pvPower + batPower - gridPower > 0;

  double get loadPower => max(pvPower + batPower - gridPower, 0);

  List<bool> get powerStates =>
      [isPvActive, isLoadActive, isBatActive, isGridActive];

  List<double> get powerValues =>
      [pvPower, loadPowerC ?? loadPower, batPower, gridPower]..toList();

  bool get isPvActive => isValid && pvPower.isPositive;

  bool get isLoadActive => isValid;

  bool get isBatActive => isValid && batPower != 0;

  bool get isGridActive => isValid && gridPower != 0;

  double get pvToLoad => isValid ? min(pvPower, loadPower) : 0;

  double get pvToBat =>
      isValid ? min(max(-batPower, 0), pvPower - pvToLoad) : 0;

  double get pvToGrid =>
      isValid ? min(gridPower, pvPower - pvToLoad - pvToBat) : 0;

  double get batToLoad => isValid ? min(batPower, loadPower - pvToLoad) : 0;

  double get batToGrid => isValid ? max(batPower - batToLoad, 0) : 0;

  double get gridToLoad =>
      isValid ? min(-gridPower, max(loadPower - pvToLoad - pvToBat, 0)) : 0;

  double get gridToBat => isValid ? max(-gridPower - gridToLoad, 0) : 0;

  List<void Function(TapDownDetails)?> get onTaps =>
      [onPvTap, onLoadTap, onBatTap, onGridTap];

  List<Widget?> get icons => [pvIcon, loadIcon, batIcon, gridIcon];

  EnergyFlowModel copyWith({
    double? pvPower,
    double? batPower,
    double? gridPower,
    double? loadPowerC,
    bool? displayKiloWattsAsSmallest,
    bool? displayAsUnsigned,
    bool? displayPowerChangeIndicationColor,
    bool? isDisabled,
    Widget? pvIcon,
    Widget? loadIcon,
    Widget? batIcon,
    Widget? gridIcon,
    void Function(TapDownDetails)? onPvTap,
    void Function(TapDownDetails)? onLoadTap,
    void Function(TapDownDetails)? onBatTap,
    void Function(TapDownDetails)? onGridTap,
    ThemeMode? themeMode = ThemeMode.light,
  }) {
    return EnergyFlowModel(
        pvPower: pvPower ?? this.pvPower,
        batPower: batPower ?? this.batPower,
        gridPower: gridPower ?? this.gridPower,
        loadPowerC: loadPowerC,
        displayKiloWattsAsSmallest:
            displayKiloWattsAsSmallest ?? this.displayKiloWattsAsSmallest,
        displayAsUnsigned: displayAsUnsigned ?? this.displayAsUnsigned,
        displayPowerChangeIndicationColor: displayPowerChangeIndicationColor ??
            this.displayPowerChangeIndicationColor,
        isDisabled: isDisabled ?? this.isDisabled,
        pvIcon: pvIcon,
        loadIcon: loadIcon,
        batIcon: batIcon,
        gridIcon: gridIcon,
        onPvTap: onPvTap,
        onLoadTap: onLoadTap,
        onBatTap: onBatTap,
        onGridTap: onGridTap,
        themeMode: themeMode ?? this.themeMode);
  }
}

extension DoubleExtension on double {
  bool get isPositive => this > 0;
}
