import 'package:flutter/material.dart';
import 'package:metropass/controller/user_ticket_controller.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/my_ticket_card.dart';
import 'package:metropass/widgets/skeleton/user_ticket_card_skeleton.dart';

class MyTicketList extends StatelessWidget {
  final String userTicketStatus;
  MyTicketList({
    super.key,
    required this.userTicketStatus,
  });
  final UserTicketController _controller = UserTicketController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller.getTicketsByStatus(userTicketStatus), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) => const UserTicketCardSkeleton(),
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
        final userTicket = snapshot.data!.toList();
        return ListView.separated(
          //shrinkWrap: true,
          //physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => MyTicketCard(userTicket: userTicket[index], userTicketStatus: userTicketStatus,), 
          separatorBuilder: (_, _) => const SizedBox(height: 0,), 
          itemCount: userTicket.length
        );
      }
    );
  }
}