

class RouteModel {
  final String name;
  final String from;
  final String to;
  final int orderIndex;
  final String zone;
  RouteModel({
    required this.name,
    required this.from,
    required this.to,
    required this.orderIndex,
    required this.zone,
  });
  factory RouteModel.fromMap(Map<String, dynamic> map, String id) {
    return RouteModel(
      name: map['name']?.toString() ?? '',
      from: map['from']?.toString() ?? '',
      to: map['to']?.toString() ?? '',
      orderIndex: map['order_index'] is int
          ? map['order_index']
          : int.tryParse(map['order_index'].toString()) ?? 0,
      zone: map['zone']?.toString() ?? '',
    );
  }
}