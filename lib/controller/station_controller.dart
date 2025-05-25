import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metropass/models/station_model.dart';

class StationController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<List<StationModel>> getStations(){
    return _db.collection('stations').snapshots().map(
      (snapshot) {
        final list = snapshot.docs.map(
          (doc) => StationModel.fromMap(doc.data(), doc.id)
        ).toList();
        list.sort((a,b) => a.orderIndex.compareTo(b.orderIndex));
        return list;
      }
    );
  }
}