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
  factory PaymentMethodModel.fromMap(Map<String, dynamic> map, String id){
    return PaymentMethodModel(
      id: id, 
      name: map['name'] ?? '', 
      status: map['status'] ?? '',
      orderIndex: map['order_index'] ?? 0,
      logoUrl: map['logo_url'] ?? 'https://www.freeiconspng.com/thumbs/credit-card-icon-png/credit-card-black-png-0.png'
    );
  }
}