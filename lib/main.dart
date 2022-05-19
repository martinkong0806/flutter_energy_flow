import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_energy_flows/energy_flows/energy_flow_icon/apperance/energy_flow_appearance.dart';
import 'package:flutter_energy_flows/energy_flows/model/energy_flow_model.dart';

import 'energy_flows/energy_flows.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EnergyFlowModel model = EnergyFlowModel(
      displayKiloWattsAsSmallest: true,
      pvPower: 2000,
      batPower: 1,
      // loadPowerC: 20,
      gridPower: 1412,
      // pvPower: 2307,
      // batPower: -2549,
      // // loadPowerC: 20,
      // gridPower: -5000,
      displayAsUnsigned: true,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: EnergyFlows(
          appearance: EnergyFlowAppearance.light,
          model: model.copyWith(onPvTap: (TapDownDetails details) {})),
    );
  }
}
