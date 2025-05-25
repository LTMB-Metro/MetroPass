
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
  factory RouteModel.fromMap(Map<String, dynamic> map, String id){
    return RouteModel(
      name: map['name'] ?? '', 
      from: map['from'] ?? '', 
      to: map['to'] ?? '',
      orderIndex: map['order_index'] ?? 0,
      zone: map['zone'] ?? ''
    );
  }
}