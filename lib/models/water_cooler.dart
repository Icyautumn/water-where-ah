import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:water_where_ah/models/enums/approval_status.enum.dart';

part 'water_cooler.g.dart';

@JsonSerializable(explicitToJson: true)
class WaterCoolerList {
  WaterCoolerList({
    required this.waterCoolers,
  });

  List<WaterCooler> waterCoolers;

  factory WaterCoolerList.fromFirestore(QuerySnapshot querySnapshot) {
    return WaterCoolerList(
      waterCoolers: querySnapshot.docs
          .map((documentSnapshot) => WaterCooler.fromFirestore(documentSnapshot))
          .toList(),
    );
  }

  factory WaterCoolerList.fromJson(Map<String, dynamic> json) => _$WaterCoolerListFromJson(json);
  Map<String, dynamic> toJson() => _$WaterCoolerListToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WaterCooler {
  WaterCooler({
    required this.id,
    required this.operator,
    required this.location,
    required this.isWorking,
    required this.bottleFriendly,
    required this.isWheelchairFriendly,
    required this.hasCold,
    required this.hasHot,
    required this.remarks,
    required this.approvalStatus,
  });

  @JsonKey(includeFromJson: true, includeToJson: false)
  String id;

  String operator;

  @JsonKey(fromJson: decodeWaterCoolerLocation, toJson: encodeWaterCoolerLocation)
  LatLng location;

  bool isWorking;
  bool bottleFriendly;
  bool isWheelchairFriendly;
  bool hasCold;
  bool hasHot;
  String remarks;

  @JsonKey(fromJson: decodeApprovalStatus, toJson: encodeApprovalStatus)
  ApprovalStatus approvalStatus;

  static LatLng decodeWaterCoolerLocation(GeoPoint waterCoolerGeoPoint) {
    return LatLng(waterCoolerGeoPoint.latitude, waterCoolerGeoPoint.longitude);
  }

  static GeoPoint encodeWaterCoolerLocation(LatLng waterCoolerLocation) {
    return GeoPoint(waterCoolerLocation.latitude, waterCoolerLocation.longitude);
  }

  static ApprovalStatus decodeApprovalStatus(int approvalStatus) {
    return ApprovalStatus.values[approvalStatus];
  }

  static int encodeApprovalStatus(ApprovalStatus approvalStatus) {
    return ApprovalStatus.values.indexOf(approvalStatus);
  }

  factory WaterCooler.fromFirestore(DocumentSnapshot doc) =>
      WaterCooler.fromJson(doc.data()! as Map<String, dynamic>)..id = doc.id;

  factory WaterCooler.fromJson(Map<String, dynamic> json) => _$WaterCoolerFromJson(json);
  Map<String, dynamic> toJson() => _$WaterCoolerToJson(this);
}
