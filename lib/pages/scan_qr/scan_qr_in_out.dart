import 'package:flutter/material.dart';
import 'package:metropass/controllers/station_controller.dart';
import 'package:metropass/models/station_model.dart';
import 'package:metropass/pages/scan_qr/scan_qr.dart';
import 'package:metropass/widgets/skeleton/ticket_card_skeleton.dart';

class ScanQrInOut extends StatelessWidget {
  final String typeScan;
  const ScanQrInOut({
    super.key,
    required this.typeScan
  });

  @override
  Widget build(BuildContext context) {
    final String type = typeScan == 'scanin' ? 'Quét tại ga vào' : 'Quét mã tại ga ra';
    return Scaffold(
      appBar: AppBar(title: Text(type)),
      body: StreamBuilder<List<StationModel>>(
        stream: StationController().getStations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) => const TicketCardSkeleton(),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có dữ liệu'));
          }
          final stations = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: stations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final station = stations[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.qr_code_scanner, color: Colors.blue),
                  title: Text(
                    station.stationName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Quét mã QR tại ga này'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanQr(station: station, typeScan: typeScan,),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}