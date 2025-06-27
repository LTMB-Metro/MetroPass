import 'package:cloud_firestore/cloud_firestore.dart';

class UserTicketModel {
  final String userTicketId;
  final String userId;
  final String ticketName;
  final String ticketType;
  final String note;
  final String description;
  final int price;
  final int duration;
  final String startStationCode;
  final String endStationCode;
  final String status;
  final DateTime bookingTime;
  final DateTime? activateTime;
  final DateTime? inactiveTime;
  final DateTime? autoActivateTime;
  final String qrCodeContent;
  final int? numberUsed;
  final String? typeScan;
  final String? isScan;

  UserTicketModel({
    required this.userTicketId,
    required this.userId,
    required this.ticketName,
    required this.ticketType,
    required this.note,
    required this.description,
    required this.price,
    required this.duration,
    required this.startStationCode,
    required this.endStationCode,
    required this.status,
    required this.bookingTime,
    this.activateTime,
    this.inactiveTime,
    required this.qrCodeContent,
    this.autoActivateTime,
    this.numberUsed,
    this.typeScan,
    this.isScan
  });

  factory UserTicketModel.fromMap(Map<String, dynamic> map, String id) {
    return UserTicketModel(
      userTicketId: id,
      userId: map['user_id']?.toString() ?? '',
      ticketName: map['ticket_name']?.toString() ?? '',
      ticketType: map['ticket_type']?.toString() ?? '',
      note: map['note']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: map['price'] is int ? map['price'] : int.tryParse(map['price'].toString()) ?? 0,
      duration: map['duration'] is int ? map['duration'] : int.tryParse(map['duration'].toString()) ?? 0,
      startStationCode: map['start_station_code']?.toString() ?? '',
      endStationCode: map['end_station_code']?.toString() ?? '',
      status: map['status']?.toString() ?? 'unused',
      bookingTime: (map['booking_time'] as Timestamp).toDate(),
      activateTime: map['activate_time'] != null
          ? (map['activate_time'] as Timestamp).toDate()
          : null,
      inactiveTime: map['inactive_time'] != null
          ? (map['inactive_time'] as Timestamp).toDate()
          : null,
      qrCodeContent: map['qr_code_content']?.toString() ?? '',
      autoActivateTime: map['auto_activate_time'] != null
          ? (map['auto_activate_time'] as Timestamp).toDate()
          : null,
      numberUsed: map['number_used'] is int ? map['number_used'] : int.tryParse(map['number_used'].toString()),
      typeScan: map['type_scan']?.toString(),
      isScan: map['is_scan']?.toString() ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'ticket_name': ticketName,
      'ticket_type': ticketType,
      'note' : note,
      'description': description,
      'price': price,
      'duration': duration,
      'start_station_code': startStationCode,
      'end_station_code': endStationCode,
      'status': status,
      'booking_time': bookingTime,
      if (activateTime != null) 'activate_time': activateTime,
      if (inactiveTime != null) 'inactive_time': inactiveTime,
      if (autoActivateTime != null) 'auto_activate_time': autoActivateTime,
      'qr_code_content': qrCodeContent,
      if (numberUsed != null) 'number_used': numberUsed,
      'type_scan': typeScan,
      if (isScan != null) 'is_scan': isScan,
    };
  }
  
}
