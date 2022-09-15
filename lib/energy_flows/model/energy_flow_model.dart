import 'dart:math';

import 'package:flutter/material.dart';

class EnergyFlowModel {
  EnergyFlowModel(
      {this.pvPower = 0,
      this.batPower = 0,
      this.gridPower = 0,
      this.tariffPower = 0,
      this.evPower = 0,
      this.smartPlugsPower = 0,
      this.loadPowerC,
      this.displayKiloWattsAsSmallest = true,
      this.displayPowerChangeIndicationColor = false,
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

  final double tariffPower;

  final double evPower;

  final double smartPlugsPower;

  /// Custome loadPower, if load power is not specified,
  ///  the load power will be calaulated. The value is not
  /// involved in calcuation.
  final double? loadPowerC;

  final bool displayKiloWattsAsSmallest;

  final bool displayPowerChangeIndicationColor;

  /// TODO, this flag is will casue bug currently, scheduled to fix.
  /// Show power values unsigned
  final bool displayAsUnsigned;

  final bool isDisabled;

  /// Unlogical power values may occur if the system consist more than 1 inverter
  bool get isValid => isDisabled ? false : pvPower + batPower - gridPower > 0;

  double get loadPower => max(pvPower + batPower - gridPower, 0);

  List<bool> get powerStates => [
        isPvActive,
        isLoadActive,
        isBatActive,
        isGridActive,
        isTariffActive,
        isEvActive,
        isSmartPlugsActive
      ];

  List<double> get powerValues => [
        pvPower,
        loadPowerC ?? loadPower,
        batPower,
        gridPower,
        tariffPower,
        evPower,
        smartPlugsPower
      ];

  List<String> get powerValuesString =>
      powerValues.map(powerValuesAsString).toList();

  bool get isPvActive => isValid && pvPower.isPositive;

  bool get isLoadActive => isValid;

  bool get isBatActive => isValid && batPower != 0;

  bool get isGridActive => isValid && gridPower != 0;

  bool get isTariffActive => isValid && tariffPower != 0;

  bool get isEvActive => isValid && evPower != 0;

  bool get isSmartPlugsActive => isValid && smartPlugsPower != 0;

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

  String powerValuesAsString(double value) {
    if (isDisabled) return '---';
    if (displayAsUnsigned) value = value.abs();

    String unit = "W";
    if (value < pow(10, 4) && !displayKiloWattsAsSmallest) {
      return value.toInt().toString() + " " + unit;
    }
    if (value >= pow(10, 7)) {
      unit = "MW";
      value /= 1000 * 1000;
    } else if (value < pow(10, 7) || displayKiloWattsAsSmallest) {
      unit = "kW";
      if (value == 0) return "0" " " + unit;
      value /= 1000;
    }

    int exponent = min(2 - max(log(value.abs()), 0) ~/ log(10), 2);
    value = (value * pow(10, exponent)).round() / pow(10, exponent);

    /// if value is larger than 1000, view without decimal
    if (value >= pow(10, 3)) return value.toInt().toString() + " " + unit;
    if (value == 0) return '0.01' " " + unit;
    return value.toString() + " " + unit;
  }

  // List<Widget?> get icons => [pvIcon, loadIcon, batIcon, gridIcon];

  EnergyFlowModel copyWith({
    double? pvPower,
    double? batPower,
    double? gridPower,
    double? tariffPower,
    double? evPower,
    double? smartPlugsPower,
    double? loadPowerC,
    bool? displayKiloWattsAsSmallest,
    bool? displayAsUnsigned,
    bool? displayPowerChangeIndicationColor,
    bool? isDisabled,
    ThemeMode? themeMode = ThemeMode.light,
  }) {
    return EnergyFlowModel(
      pvPower: pvPower ?? this.pvPower,
      batPower: batPower ?? this.batPower,
      gridPower: gridPower ?? this.gridPower,
      tariffPower: tariffPower ?? this.tariffPower,
      evPower: evPower ?? this.evPower,
      smartPlugsPower:  smartPlugsPower ?? this.smartPlugsPower,
      loadPowerC: loadPowerC,
      displayKiloWattsAsSmallest:
          displayKiloWattsAsSmallest ?? this.displayKiloWattsAsSmallest,
      displayAsUnsigned: displayAsUnsigned ?? this.displayAsUnsigned,
      displayPowerChangeIndicationColor: displayPowerChangeIndicationColor ??
          this.displayPowerChangeIndicationColor,
      isDisabled: isDisabled ?? this.isDisabled,
    );
  }
}

extension DoubleExtension on double {
  bool get isPositive => this > 0;
}
