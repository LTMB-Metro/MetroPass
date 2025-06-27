class PaymentMethodModel {
  final String id;
  final String name;
  final String status;
  final int orderIndex;
  final String logoUrl;
  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.status,
    required this.orderIndex,
    required this.logoUrl
  });
  factory PaymentMethodModel.fromMap(Map<String, dynamic> map, String id) {
    return PaymentMethodModel(
      id: id,
      name: map['name']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      orderIndex: map['order_index'] is int
          ? map['order_index']
          : int.tryParse(map['order_index'].toString()) ?? 0,
      logoUrl: map['logo_url']?.toString() ??
          'https://www.freeiconspng.com/thumbs/credit-card-icon-png/credit-card-black-png-0.png',
    );
  }
}