import 'dart:math';

class EnergyFlowModel {
  EnergyFlowModel(
      {this.pvPower = 0,
      this.batPower = 0,
      this.gridPower = 0,
      this.onPvTap,
      this.onLoadTap,
      this.onBatTap,
      this.onGridTap,
      this.displayAsUnsigned = true});

  /// in Watts
  final double pvPower;
  // in Watts
  // Negative as charging, positive as discharging
  final double batPower;
  // in Watts
  // Negative as importing, positive as exporting
  final double gridPower;

  final void Function()? onPvTap, onLoadTap, onBatTap, onGridTap;

  /// Show power values unsigned
  final bool displayAsUnsigned;

  /// Unlogical power values may occur if the system consist more than 1 inverter
  bool get isValid => pvPower + batPower - gridPower > 0;

  double get loadPower => max(pvPower + batPower - gridPower, 0);

  List<bool> get powerStates =>
      [isPvActive, isLoadActive, isBatActive, isGridActive];

  List<String> get powerValues => [pvPower, loadPower, batPower, gridPower]
      .map(powerValuesAsString)
      .toList();

  List<void Function()?> get onTaps =>
      [onPvTap, onLoadTap, onBatTap, onGridTap];

  String powerValuesAsString(double value) {
    value = value / 1000;
    if (displayAsUnsigned) value = value.abs();
 
    int exponent = min(3 - max(log(value),0)~/log(10),3);
    value = (value * pow(10, exponent)).round() / pow(10, exponent);
    if (value == 0) return "0 kW";
    return value.toString() + " kW";
  }

  bool get isPvActive => isValid && pvPower.isPositive;

  bool get isLoadActive => isValid;

  bool get isBatActive => isValid && batPower != 0;

  bool get isGridActive => isValid && gridPower != 0;

  double get pvToLoad => isValid ? min(pvPower, loadPower) : 0;

  double get pvToBat => isValid ? min(-batPower, pvPower - pvToLoad) : 0;

  double get pvToGrid =>
      isValid ? min(gridPower, pvPower - loadPower - batPower) : 0;

  double get batToLoad => isValid ? min(batPower, loadPower - pvToLoad) : 0;

  double get batToGrid => isValid ? max(batPower - batToLoad, 0) : 0;

  double get gridToLoad =>
      isValid ? min(-gridPower, max(loadPower - pvToLoad - pvToBat, 0)) : 0;

  double get gridToBat => isValid ? max(-gridPower - gridToLoad, 0) : 0;
}

extension DoubleExtension on double {
  bool get isPositive => this > 0;
}
