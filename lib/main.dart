import 'dart:math';

import 'package:flutter/material.dart';
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
        pvPower: 28762,
        batPower: 0,
        gridPower: 500,
        displayAsUnsigned: true,
        onPvTap: () {
          print("pv");
        });

    print(model.gridToLoad);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          // color: Colors.b,
          child: EnergyFlows(model: model),
        ));
  }
}
