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

  test("random test 1", () {
    EnergyFlowModel model =
        EnergyFlowModel(pvPower: 2007, gridPower: 4246, batPower: 2549);
    expect(model.loadPower, 310);
    expect(model.pvToBat, 0);
    expect(model.pvToGrid, 1697);
    // expect(model.gridToLoad, 500);
    // expect(model.gridToBat, 2500);
  });

  test("powerValuesAsString()", (() {
    EnergyFlowModel model = EnergyFlowModel();
    expect(model.powerValuesAsString(250), "250 W");
    expect(model.powerValuesAsString(2500), "2500 W");
    expect(model.powerValuesAsString(25000), "25 kW");
    expect(model.powerValuesAsString(250000), "250 kW");
    expect(model.powerValuesAsString(2500000), "2500 kW");
    expect(model.powerValuesAsString(25000000), "25 MW");
  }));
}
