import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metropass/models/station_model.dart';
import 'package:metropass/models/ticket_type_model.dart';

class CreateTicketType {
  final StationModel station;

  CreateTicketType({required this.station});

  Stream<List<StationModel>> get stationStream {
    return FirebaseFirestore.instance
        .collection('stations')
        .where('zone', isEqualTo: station.zone)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => StationModel.fromMap(doc.data(), doc.id))
              .where((s) => s.code != station.code)
              .toList()
            ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        });
  }

  Stream<List<TicketTypeModel>> get ticketStream async* {
    await for (final stations in stationStream) {
      final priceSettingSnap =
          await FirebaseFirestore.instance
              .collection('price_setting')
              .where('name', isEqualTo: 'original_price')
              .limit(1)
              .get();

      final originalPrice =
          priceSettingSnap.docs.isNotEmpty
              ? priceSettingSnap.docs.first['price'] as int
              : 0;

      final originalGrap =
          priceSettingSnap.docs.isNotEmpty
              ? priceSettingSnap.docs.first['original_grap'] as int
              : 0;

      final tickets =
          stations.map((sta) {
            final grap = (station.orderIndex - sta.orderIndex).abs();
            final price =
                grap <= originalGrap
                    ? originalPrice
                    : originalPrice + (grap - originalGrap) * 1000;

            return TicketTypeModel(
              description:
                  'Vé lượt: ${station.stationName} - ${sta.stationName}',
              duration: 30,
              note: 'Vé sử dụng một lần',
              ticketName: 'Đến ga ${sta.stationName}',
              type: 'single',
              categories: 'normal',
              price: price,
              fromCode: station.code,
              toCode: sta.code,
              qrCodeURL: '',
            );
          }).toList();

      yield tickets;
    }
  }
}
