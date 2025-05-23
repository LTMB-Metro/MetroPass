class RouteModel {
  final String name;
  final String from;
  final String to;
  final int order_index;
  RouteModel({
    required this.name,
    required this.from,
    required this.to,
    required this.order_index
  });
  factory RouteModel.fromMap(Map<String, dynamic> map, String id){
    return RouteModel(
      name: map['name'] ?? '', 
      from: map['from'] ?? '', 
      to: map['to'] ?? '',
      order_index: map['order_index'] ?? 0,
    );
  }
}