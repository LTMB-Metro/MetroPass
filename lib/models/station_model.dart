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
  factory StationModel.fromMap(Map<String, dynamic> map, String id){
    return StationModel(
      id: id,
      code: map['code'] ?? '', 
      location: map['location'] ?? const GeoPoint(0.0, 0.0), 
      orderIndex: map['order_index'] ?? 0,
      stationName: map['station_name'] ?? '',
      status: map['status'] ?? '',
      type: map['type'] ?? '',
      zone: map['zone'] ?? '',
    );
  }
}