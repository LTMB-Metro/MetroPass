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

  factory TicketTypeModel.fromMap(Map<String, dynamic> map, String id) {
    return TicketTypeModel(
      description: map['description']?.toString() ?? '',
      duration: map['duration'] is int
          ? map['duration']
          : int.tryParse(map['duration'].toString()) ?? 0,
      note: map['note']?.toString() ?? '',
      ticketName: map['ticket_name']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      categories: map['categories']?.toString() ?? '',
      price: map['price'] is int
          ? map['price']
          : int.tryParse(map['price'].toString()) ?? 0,
      fromCode: map['from_code']?.toString() ?? '',
      toCode: map['to_code']?.toString() ?? '',
      qrCodeURL: map['qr_code_URL']?.toString() ?? '',
    );
  }
}