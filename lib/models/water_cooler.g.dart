// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_cooler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterCoolerList _$WaterCoolerListFromJson(Map<String, dynamic> json) =>
    WaterCoolerList(
      waterCoolers: (json['waterCoolers'] as List<dynamic>)
          .map((e) => WaterCooler.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WaterCoolerListToJson(WaterCoolerList instance) =>
    <String, dynamic>{
      'waterCoolers': instance.waterCoolers.map((e) => e.toJson()).toList(),
    };

WaterCooler _$WaterCoolerFromJson(Map<String, dynamic> json) => WaterCooler(
      id: json['id'] ?? '',
      operator: json['operator'] as String,
      location:
          WaterCooler.decodeWaterCoolerLocation(json['location'] as GeoPoint),
      isWorking: json['isWorking'] as bool,
      bottleFriendly: json['bottleFriendly'] as bool,
      hasCold: json['hasCold'] as bool,
      hasHot: json['hasHot'] as bool,
      remarks: json['remarks'] as String,
      wheelchairFriendly: WaterCooler.decodeWheelchairFriendly(
        json['wheelchairFriendly'] as int,
      ),
      approvalStatus: WaterCooler.decodeApprovalStatus(
        json['isApproved'] as int,
      ),
      reportCount: json['reportCount'] as int,
    );

Map<String, dynamic> _$WaterCoolerToJson(WaterCooler instance) =>
    <String, dynamic>{
      'operator': instance.operator,
      'location': WaterCooler.encodeWaterCoolerLocation(instance.location),
      'isWorking': instance.isWorking,
      'bottleFriendly': instance.bottleFriendly,
      'hasCold': instance.hasCold,
      'hasHot': instance.hasHot,
      'remarks': instance.remarks,
      'reportCount': instance.reportCount,
      'isApproved': WaterCooler.encodeApprovalStatus(instance.approvalStatus),
      'wheelchairFriendly': WaterCooler.encodeWheelchairFriendly(
        instance.wheelchairFriendly,
      ),
    };
