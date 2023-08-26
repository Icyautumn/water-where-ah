import 'package:flutter/material.dart';
import 'package:water_where_ah/models/enums/wheelchair_friendly.enum.dart';
import 'package:water_where_ah/models/water_cooler.dart';

class WaterCoolerInfoWidget extends StatelessWidget {
  final WaterCooler waterCooler;
  const WaterCoolerInfoWidget({
    super.key,
    required this.waterCooler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                waterCooler.operator,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              ElevatedButton(onPressed: () {}, child: const Text('Report'))
            ],
          ),
          const SizedBox(height: 16),
          ...[
            'Location: ${waterCooler.location.latitude}, ${waterCooler.location.longitude}',
            'Approval status: ${waterCooler.approvalStatus}',
          ].map((e) => Chip(label: Text(e))).toList(),
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
    );
  }
}
