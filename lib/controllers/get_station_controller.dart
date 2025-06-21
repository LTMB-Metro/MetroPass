import 'package:cloud_firestore/cloud_firestore.dart';

class GetStationController {
  final String ticketCode;
  GetStationController({
    required this.ticketCode
  });
  Future<String> getStationByCode() async {
    final snapshot = await FirebaseFirestore.instance
      .collection('stations')
      .where('code', isEqualTo: ticketCode)
      .limit(1)
      .get();

    if(snapshot.docs.isNotEmpty){
      final data = snapshot.docs.first.data();
      return data['station_name'] ?? 'Không tìm thấy tên ga';
    }else{
      return 'Không tìm thấy ga';
    }
  }
}