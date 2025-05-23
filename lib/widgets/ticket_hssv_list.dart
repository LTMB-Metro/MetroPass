import 'package:flutter/material.dart';
import 'package:metropass/controller/ticket_type_controller.dart';
import 'package:metropass/widgets/skeleton/ticket_card_skeleton.dart';
import 'package:metropass/widgets/ticket_card.dart';

class TicketHssvList extends StatelessWidget {
  TicketHssvList({super.key});

  //@override
  final TicketTypeController _controller = TicketTypeController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller.getTicketType(), 
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) => const TicketCardSkeleton(),
          );
        }
        if(!snapshot.hasData || snapshot.data!.isEmpty){
          return const Center(child: Text('Không có vé nào'),);
        }
        final ticketCard = snapshot.data!
          .where((ticket) => ticket.categories == 'student' && ticket.type != 'single')
          .toList();
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => TicketCard(Ticket: ticketCard[index]), 
          separatorBuilder: (_, _) => const SizedBox(height: 10,), 
          itemCount: ticketCard.length
        );
      }
    );
  }
}