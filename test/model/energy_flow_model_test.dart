import 'dart:math';

import 'package:flutter_energy_flows/energy_flows/model/energy_flow_model.dart';
import 'package:test/test.dart';

void main() {
  test("Get Correct Load Power", () {
    EnergyFlowModel model =
        EnergyFlowModel(pvPower: 2000, batPower: -1000, gridPower: 500);
    expect(model.loadPower, 500);
  });

  test("Solar charge to Load and Battery", () {
    EnergyFlowModel model = EnergyFlowModel(pvPower: 2000, batPower: -1000);
    expect(model.loadPower, 1000);
    expect(model.pvToLoad, 1000);
    expect(model.pvToBat, 1000);
    expect(model.pvToGrid, 0);
  });

  test("Solar charge to Load and Battery and grid", () {
    EnergyFlowModel model =
        EnergyFlowModel(pvPower: 2000, batPower: -1000, gridPower: 200);
    expect(model.loadPower, 800);
    expect(model.pvToLoad, 800);
    expect(model.pvToBat, 1000);
    expect(model.pvToGrid, 200);
    expect(model.batToLoad, 0);
    expect(model.batToGrid, 0);
    expect(model.gridToLoad, 0);
    expect(model.gridToBat, 0);
  });

  test("Solar and Battery charge to Load", () {
    EnergyFlowModel model = EnergyFlowModel(pvPower: 2000, batPower: 1000);
    expect(model.loadPower, 3000);
    expect(model.pvToLoad, 2000);
    expect(model.batToLoad, 1000);
  });

  test("Battery charge to Load and Grid", () {
    EnergyFlowModel model = EnergyFlowModel(batPower: 1000, gridPower: 200);
    expect(model.loadPower, 800);
    expect(model.pvToLoad, 0);
    expect(model.batToLoad, 800);
    expect(model.batToGrid, 200);
  });

  test("Solar and Grid charge to Load", () {
    EnergyFlowModel model = EnergyFlowModel(pvPower: 2000, gridPower: -200);
    expect(model.loadPower, 2200);
    expect(model.pvToLoad, 2000);
    expect(model.gridToLoad, 200);
  });

  test("Grid charge to Load and Battery", () {
    EnergyFlowModel model = EnergyFlowModel(batPower: -2500, gridPower: -3000);
    expect(model.loadPower, 500);
    expect(model.gridToLoad, 500);
    expect(model.gridToBat, 2500);
  });
}
