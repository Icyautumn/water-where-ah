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
      isWheelchairFriendly: json['isWheelchairFriendly'] as bool,
      hasCold: json['hasCold'] as bool,
      hasHot: json['hasHot'] as bool,
      remarks: json['remarks'] as String,
      approvalStatus:
          WaterCooler.decodeApprovalStatus(json['isApproved'] as int),
    );

Map<String, dynamic> _$WaterCoolerToJson(WaterCooler instance) =>
    <String, dynamic>{
      'operator': instance.operator,
      'location': WaterCooler.encodeWaterCoolerLocation(instance.location),
      'isWorking': instance.isWorking,
      'bottleFriendly': instance.bottleFriendly,
      'isWheelchairFriendly': instance.isWheelchairFriendly,
      'hasCold': instance.hasCold,
      'hasHot': instance.hasHot,
      'remarks': instance.remarks,
      'isApproved': WaterCooler.encodeApprovalStatus(instance.approvalStatus),
    };
