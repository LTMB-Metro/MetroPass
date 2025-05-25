class TicketTypeModel {
  final String description;
  final int duration;
  final String note;
  final String ticketName;
  final String type;
  final String categories;
  final int price;
  final String fromCode;
  final String toCode;
  final String  qrCodeURL;
  
  TicketTypeModel({
    required this.description,
    required this.duration,
    required this.note,
    required this.ticketName,
    required this.type,
    required this.categories,
    required this.price,
    required this.fromCode,
    required this.toCode,
    required this.qrCodeURL
  });

  factory TicketTypeModel.fromMap(Map<String, dynamic> map, String id){
    return TicketTypeModel(
      description: map['description'] ?? '',
      duration: map['duration'] ?? 0,
      note: map['note'] ?? '',
      ticketName: map['ticket_name'] ?? '',
      type: map['type'] ?? '',
      categories: map['categories'] ?? '',
      price: map['price'] ?? 0,
      fromCode: map['from_code'] ?? '',
      toCode: map['to_code'] ?? '',
      qrCodeURL: map['qr_code_URL'] ?? ''
    );
  }
}