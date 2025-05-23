import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metropass/models/ticket_type_model.dart';

class TicketTypeController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<List<TicketTypeModel>> getTicketType() {
    return _db.collection('ticket_type').snapshots().map(
      (snapshot) {
        final list = snapshot.docs
          .map((doc) => TicketTypeModel.fromMap(doc.data(), doc.id))
          .toList();
        list.sort((a, b) => a.duration.compareTo(b.duration));

        return list;
      },
    );
  }
}