class TicketTypeModel {
  final String id;
  final String description;
  final int duration;
  final String note;
  final String ticketName;
  final String type;
  final String categories;
  final int price;
  
  TicketTypeModel({
    required this.id,
    required this.description,
    required this.duration,
    required this.note,
    required this.ticketName,
    required this.type,
    required this.categories,
    required this.price
  });

  factory TicketTypeModel.fromMap(Map<String, dynamic> map, String id){
    return TicketTypeModel(
      id: id,
      description: map['description'] ?? '',
      duration: map['duration'] ?? 0,
      note: map['note'] ?? '',
      ticketName: map['ticket_name'] ?? '',
      type: map['type'] ?? '',
      categories: map['categories'] ?? '',
      price: map['price'] ?? 0,

    );
  }
}