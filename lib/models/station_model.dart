import 'package:cloud_firestore/cloud_firestore.dart';

class StationModel {
  final String id;
  final String code;
  final GeoPoint location; // To store latitude & longitude
  final int orderIndex;
  final String stationName;
  final String status;
  final String type;
  final String zone;
  StationModel({
    required this.id,
    required this.code,
    required this.location,
    required this.orderIndex,
    required this.stationName,
    required this.status,
    required this.type,
    required this.zone,
  });
  factory StationModel.fromMap(Map<String, dynamic> map, String id) {
    final dynamic locationData = map['location'];
    final GeoPoint safeLocation = locationData is GeoPoint
        ? locationData
        : const GeoPoint(0.0, 0.0);

    return StationModel(
      id: id,
      code: map['code']?.toString() ?? '',
      location: safeLocation,
      orderIndex: map['order_index'] is int
          ? map['order_index']
          : int.tryParse(map['order_index'].toString()) ?? 0,
      stationName: map['station_name']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      zone: map['zone']?.toString() ?? '',
    );
  }
}