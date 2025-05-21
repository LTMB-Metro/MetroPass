import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> addSampleTickets() async {
    final ticketRef = FirebaseFirestore.instance.collection('tickets');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextMonth = DateTime(now.year, now.month + 1, 1);

    // Vé lượt
    await ticketRef.add({
      'user_id': 'user_001',
      'ticket_type': 'single',
      'start_station_code': 'BT',
      'end_station_code': 'ST',
      'start_time': Timestamp.fromDate(now.add(const Duration(hours: 1))),
      'booking_time': Timestamp.now(),
      'status': 'active',
      'price': 15000,
      'qr_code_url': 'https://example.com/qr/single-ticket.png'
    });

    // Vé ngày
    await ticketRef.add({
      'user_id': 'user_002',
      'ticket_type': 'daily',
      'valid_from': Timestamp.fromDate(today),
      'valid_until': Timestamp.fromDate(
        today.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
      ),
      'status': 'active',
      'price': 30000,
      'qr_code_url': 'https://example.com/qr/daily-ticket.png'
    });

    // Vé tháng
    await ticketRef.add({
      'user_id': 'user_003',
      'ticket_type': 'monthly',
      'valid_from': Timestamp.fromDate(DateTime(now.year, now.month, 1)),
      'valid_until': Timestamp.fromDate(
        DateTime(nextMonth.year, nextMonth.month, 0, 23, 59, 59),
      ),
      'status': 'active',
      'price': 300000,
      'qr_code_url': 'https://example.com/qr/monthly-ticket.png'
    });

    print('✅ Đã thêm 3 loại vé mẫu');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await addSampleTickets();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã thêm 3 vé mẫu vào Firestore')),
          );
        },
        child: const Text('Thêm 3 vé mẫu'),
      ),
    );
  }
}
