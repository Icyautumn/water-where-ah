import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_where_ah/models/water_cooler.dart';
import 'package:water_where_ah/widgets/watercooler_info.dart';

class DrawerTest extends StatelessWidget {
  const DrawerTest({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('watercoolers')
          .limit(1)
          .withConverter(
            fromFirestore: (snapshot, options) => WaterCooler.fromFirestore(
              snapshot,
            ),
            toFirestore: (waterCooler, options) => waterCooler.toJson(),
          )
          .get(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        var waterCooler = snapshot.data?.docs.first.data();
        return WaterCoolerInfoWidget(waterCooler: waterCooler!);
      },
    );
  }
}
