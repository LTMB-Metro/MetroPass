import 'package:flutter/material.dart';
import 'package:metropass/controller/create_ticket_type.dart';
import 'package:metropass/models/station_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/skeleton/ticket_card_skeleton.dart';
import 'package:metropass/widgets/ticket_card.dart';

class TicketSingle extends StatefulWidget {
  final StationModel station;
  const TicketSingle({
    super.key,
    required this.station
  });

  @override
  State<TicketSingle> createState() => _TicketSingleState();
}

class _TicketSingleState extends State<TicketSingle> {
  late final CreateTicketType _controller;
  @override
  void initState() {
    super.initState();
    _controller = CreateTicketType(station: widget.station);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller.ticketStream, 
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 7,
            itemBuilder: (context, index) => const TicketCardSkeleton()
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
          .where((ticket) => ticket.type == 'single')
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
          separatorBuilder: (_, _) => const SizedBox(height: 10,), 
          itemCount: ticketCard.length,
          itemBuilder: (context, index) => TicketCard(ticket: ticketCard[index]), 
        );
      }
    );
  }
}