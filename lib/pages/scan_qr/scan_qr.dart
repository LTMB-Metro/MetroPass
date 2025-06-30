import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:metropass/controllers/user_ticket_controller.dart';
import 'package:metropass/models/station_model.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQr extends StatefulWidget {
  final StationModel station;
  final String typeScan;
  const ScanQr({
    super.key,
    required this.station,
    required this.typeScan
  });

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  String? scannedCode;
  bool isScanned = false;
  bool showResultOverlay = false;
  bool isSuccess = false;

  Future<void> _validateTicket(String userTicketId, String userId) async {
    final ticket = await UserTicketController().getUserTicketById(userTicketId, userId);
    if (ticket == null) {
      _showOverlay(false);
      return;
    }

    final result = await UserTicketController().validateAndUseTicket(
      userTicketId: userTicketId,
      userId: userId,
      stationCode: widget.station.code,
      typeScan: widget.typeScan,
    );

    // Giả sử đây là dữ liệu bạn muốn cập nhật sau 3 giây
    final updateData = {
      'is_scan': 'null',
    };

    _showOverlay(result, userId: userId, userTicketId: userTicketId, updateData: updateData);
  }


  void _showOverlay(bool success, {
  String? userId,
  String? userTicketId,
  Map<String, dynamic>? updateData,
  }) {
    if (!mounted) return;
    setState(() {
      showResultOverlay = true;
      isSuccess = success;
    });
    Future.delayed(const Duration(seconds: 4), () async {
      if (!mounted) return;
      setState(() {
        showResultOverlay = false;
        isScanned = false;
        scannedCode = null;
      });
      if (success && userId != null && userTicketId != null && updateData != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('user_tickets')
            .doc(userTicketId)
            .update(updateData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quét mã QR tại ga ${widget.station.stationName}')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 4,
                child: MobileScanner(
                  controller: MobileScannerController(),
                  onDetect: (barcodeCapture) async {
                    final String? code = barcodeCapture.barcodes.isNotEmpty
                        ? barcodeCapture.barcodes.first.rawValue
                        : null;
                    if (!isScanned && code != null && !showResultOverlay) {
                      setState(() {
                        scannedCode = code;
                        isScanned = true;
                      });
                      // Tách userTicketId và userId từ mã QR
                      final parts = code.split('|');
                      final userTicketId = parts.isNotEmpty ? parts[0] : '';
                      final userId = parts.length > 1 ? parts[1] : '';
                      print('==== qr $userTicketId');
                      if (userTicketId.isEmpty || userId.isEmpty) {
                        _showOverlay(false);
                        return;
                      }
                      await _validateTicket(userTicketId, userId);
                    }
                  },
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Center(
              //     child: Text(
              //       scannedCode ?? 'Chưa có mã nào được quét',
              //       style: const TextStyle(fontSize: 18),
              //     ),
              //   ),
              // ),
            ],
          ),
          if (showResultOverlay)
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: isSuccess ? Colors.green.withOpacity(0.95) : Colors.red.withOpacity(0.95),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                        color: Colors.white,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isSuccess ? 'Thành công!\nVé hợp lệ.' : 'Thất bại!\nVé không hợp lệ hoặc đã sử dụng/hết hạn.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
