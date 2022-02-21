part of '../energy_flows.dart';

extension ToOffset on Size {
  Offset toOffset() {
    return Offset(width, height);
  }
}

extension OffsetExt on Offset {
  Offset toDistance(double direction, double distance) {
    return Offset(dx + distance * math.cos(direction),
        dy + distance * math.sin(direction));
  }
}
