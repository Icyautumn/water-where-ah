import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:water_where_ah/models/enums/wheelchair_friendly.enum.dart';
import 'package:water_where_ah/models/water_cooler.dart';

class WaterCoolerInfoWidget extends StatelessWidget {
  final WaterCooler waterCooler;
  const WaterCoolerInfoWidget({
    super.key,
    required this.waterCooler,
  });

  Future<void> openMaps(LatLng navigationLocation) async {
    var uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${navigationLocation.latitude},${navigationLocation.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  Future<void> reportWaterCooler(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('watercoolers')
        .doc(waterCooler.id)
        .update(
          (waterCooler..reportCount = waterCooler.reportCount + 1).toJson(),
        )
        .then(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Reported this watercooler"),
            ),
          ),
        )
        .catchError(
          (e) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something went wrong. Try again later"),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: Flexible(
                      child: Text(
                        waterCooler.operator,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => reportWaterCooler(context),
                    child: const Text('Report'),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text(
                waterCooler.remarks,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.accessible),
                  const SizedBox(width: 8),
                  Text(
                    waterCooler.wheelchairFriendly == WheelcharFriendly.yes
                        ? 'Wheelchair friendly'
                        : 'Not wheelchair friendly',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.local_drink),
                  const SizedBox(width: 8),
                  Text(
                    waterCooler.bottleFriendly
                        ? 'Bottle friendly'
                        : 'Not bottle friendly',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.ac_unit),
                  const SizedBox(width: 8),
                  Text(
                    waterCooler.hasCold ? 'Has cold water' : 'No cold water',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.local_fire_department),
                  const SizedBox(width: 8),
                  Text(
                    waterCooler.hasHot ? 'Has hot water' : 'No hot water',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.local_drink),
                  const SizedBox(width: 8),
                  Text(
                    waterCooler.isWorking ? 'Is working' : 'Not working',
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => openMaps(waterCooler.location),
              child: const Text("Open in Google Maps"),
            ),
          ),
        ],
      ),
    );
  }
}
