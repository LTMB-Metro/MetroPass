import 'package:flutter/material.dart';
import 'package:metropass/controllers/ticket_type_controller.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/skeleton/ticket_card_skeleton.dart';
import 'package:metropass/widgets/ticket_card.dart';

class TicketNormalList extends StatelessWidget {
  TicketNormalList({super.key});

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
            itemCount: 3,
            itemBuilder: (context, index) => const TicketCardSkeleton(),
          );
        }
        if(!snapshot.hasData || snapshot.data!.isEmpty){
          return const Center(
            child: Text(
              'Không có vé nào',
              style: TextStyle(
                color: Color(MyColor.pr9),
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          );
        }
        final ticketCard = snapshot.data!
          .where((ticket) => ticket.categories == 'normal' && ticket.type != 'single')
          .toList();
        if(ticketCard.isEmpty){
          return const Center(
            child: Text(
              'Hiện chưa có vé nào',
              style: TextStyle(
                color: Color(MyColor.pr8),
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => TicketCard(ticket: ticketCard[index]), 
          separatorBuilder: (_, _) => const SizedBox(height: 10,), 
          itemCount: ticketCard.length
        );
      }
    );
  }
}