part of '../energy_flows.dart';

const double ICON_GLOW_SIZE_MIN = 1;

const double ICON_GLOW_SIZE_MAX = 1.2;

const Duration ICON_GLOW_DURTAION = Duration(seconds: 1);

const double ENERGY_BLOB_GLOW_SCALE_MIN = 1.0;

const double ENERGY_BLOB_GLOW_SCALE_MAX = 1.75;

const Duration ENERGY_BLOB_GLOW_SCALE_DURATION = Duration(milliseconds: 500);

const Duration ENERGY_BLOB_GLOW_COLOR_DURATION = Duration(seconds: 4);

const Duration ENERGY_BLOB_GLOW_ROTATION_DURATION = Duration(seconds: 4);

const Color pvColor = Color(0xfff8dd6c);
const Color loadColor = Color(0xff4fbba9);
const Color batColor = Color(0xff233c7b);
const Color gridColor = Color(0xffeb5b56);
const Color activeRailColor = Color(0xffa2a3a3);
const Color inactiveRailColor = Color(0xffe3e2e3);

const List<EnergyFlowsIconModel> iconModels = [
  EnergyFlowsIconModel(
    name: "solar",
    color: pvColor,
    offsetDistanceRatio: 3 / 4,
    offsetDirection: 2 * math.pi * 2 / 3 + math.pi / 6,
  ),
  EnergyFlowsIconModel(
    name: "load",
    color: loadColor,
    offsetDistanceRatio: 0,
    offsetDirection: 0,
  ),
  EnergyFlowsIconModel(
    name: "battery",
    color: batColor,
    offsetDistanceRatio: 3 / 4,
    offsetDirection: 2 * math.pi / 3 + math.pi / 6,
  ),
  EnergyFlowsIconModel(
    name: "grid",
    color: gridColor,
    offsetDistanceRatio: 3 / 4,
    offsetDirection: 2 * math.pi + math.pi / 6,
  )
];
