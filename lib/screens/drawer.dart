import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_where_ah/models/water_cooler.dart';
import 'package:water_where_ah/widgets/watercooler_info.dart';

class DrawerTest extends StatelessWidget {
  final WaterCooler waterCooler;
  const DrawerTest({super.key, required this.waterCooler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(waterCooler.operator),
      ),
      body: WaterCoolerInfoWidget(waterCooler: waterCooler),
    );
  }
}
