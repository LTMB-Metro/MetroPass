import 'package:flutter/material.dart';
import 'package:metropass/widgets/my_ticket_list.dart';

class ExpriedTicketPage extends StatelessWidget {
  const ExpriedTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vé đã hết hạn'),
      ),
      body: MyTicketList(userTicketStatus: 'expired',)
    );
  }
}