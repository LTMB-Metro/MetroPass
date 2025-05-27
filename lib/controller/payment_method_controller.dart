import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metropass/models/payment_method_model.dart';

class PaymentMethodController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<List<PaymentMethodModel>> getPaymentMethod() async {
    final snapshot = await _db.collection('payment_method').get();
    final list = snapshot.docs.map(
      (doc) => PaymentMethodModel.fromMap(doc.data(), doc.id)
    ).toList();
    list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return list;
  }
}