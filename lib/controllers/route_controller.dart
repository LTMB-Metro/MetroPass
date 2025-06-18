import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metropass/models/route_model.dart';

class RouteController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<List<RouteModel>> getRoute(){
    return _db.collection('route').snapshots().map(
      (snapshot) {
        final list = snapshot.docs
          .map(
            (doc) => RouteModel.fromMap(doc.data(), doc.id)
          ).toList();
        list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        return list;
      }
    );
  }
}