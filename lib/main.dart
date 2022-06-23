import 'dart:async';
import 'dart:math' as math;

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
      showSemanticsDebugger: true,
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
  late double pvPower;
  late double batPower;
  late double gridPower;
  @override
  void initState() {
    pvPower = 0;
    batPower = 0;
    gridPower = 0;

    _getValues();
    super.initState();
  }

  _getValues() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        pvPower += (math.Random().nextDouble() - 0.25) * 10;
        pvPower = math.max(pvPower, 0);
        batPower += (math.Random().nextDouble() - 0.5) * 10;
        gridPower += (math.Random().nextDouble() - 0.5) * 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    EnergyFlowModel model = EnergyFlowModel(
      pvPower: pvPower,
      batPower: batPower,
      gridPower: gridPower,
      displayAsUnsigned: false,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: EnergyFlows(
          appearance: EnergyFlowAppearance.light,
          model: model.copyWith(
              displayKiloWattsAsSmallest: false,
              // displayAsUnsigned: true,
             )),
    );
  }
}
