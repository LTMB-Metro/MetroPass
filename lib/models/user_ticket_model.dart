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
  final String qrCodeContent;

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
    required this.qrCodeContent,
  });

  factory UserTicketModel.fromMap(Map<String, dynamic> map, String id) {
    return UserTicketModel(
      userTicketId: id, 
      userId: map['user_id'] ?? '',
      ticketName: map['ticket_name'] ?? '',
      ticketType: map['ticket_type'] ?? '',
      note: map['note'] ?? '',
      price: map['price'] ?? 0,
      description: map['description'] ?? '',
      duration: map['duration'] ?? 0,
      startStationCode: map['start_station_code'] ?? '',
      endStationCode: map['end_station_code'] ?? '',
      status: map['status'] ?? 'unused',
      bookingTime: (map['booking_time'] as Timestamp).toDate(),
      activateTime: map['activate_time'] != null
          ? (map['activate_time'] as Timestamp).toDate()
          : null,
      qrCodeContent: map['qr_code_content'] ?? '',
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
      'qr_code_content': qrCodeContent,
    };
  }
}
