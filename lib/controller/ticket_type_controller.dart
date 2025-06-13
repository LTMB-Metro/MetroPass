import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metropass/models/station_model.dart';
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

  Future<List<TicketTypeModel>> getAllTicketTypes() async {
    final snapshot = await _db.collection('ticket_type').get();
    final list = snapshot.docs
        .map((doc) => TicketTypeModel.fromMap(doc.data(), doc.id))
        .toList();
    list.sort((a, b) => a.duration.compareTo(b.duration));
    return list;
  }
  
  Future<TicketTypeModel> getTicketsOnce({
    required StationModel fromStation,
    required StationModel toStation,
    required int price,
  }) async {
    return TicketTypeModel(
      description: 'Vé lượt: ${fromStation.stationName} - ${toStation.stationName}',
      duration: 30,
      note: 'Vé sử dụng một lần',
      ticketName: 'Từ ga ${fromStation.stationName} đến ga ${toStation.stationName}',
      type: 'single',
      categories: 'normal',
      price: price,
      fromCode: fromStation.code,
      toCode: toStation.code,
      qrCodeURL: '',
    );
  }
}