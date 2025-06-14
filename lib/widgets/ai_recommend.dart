import 'package:flutter/material.dart';
import 'package:metropass/controller/user_ticket_controller.dart';
import 'package:metropass/models/ticket_type_model.dart';
import 'package:metropass/widgets/ticket_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AiRecommend extends StatelessWidget {
  const AiRecommend({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TicketTypeModel>>(
      stream: UserTicketController().getTicketTypesFromUserTickets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        final tickets = snapshot.data!;
        final Map<String, int> typeCount = {};

        for (var ticket in tickets) {
          final name = ticket.ticketName.trim();
          if (name.isNotEmpty) {
            typeCount[name] = (typeCount[name] ?? 0) + 1;
          }
        }

        final sorted = typeCount.entries
            .where((e) => e.value > 2)
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final topTwoNames = sorted.take(2).map((e) => e.key).toList();

        final List<TicketTypeModel> topTickets = [];
        for (var name in topTwoNames) {
          final ticket = tickets.firstWhere((t) => t.ticketName == name);
          topTickets.add(ticket);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (topTickets.isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!.suggestion,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              itemCount: topTickets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final ticket = topTickets[index];
                return TicketCard(ticket: ticket);
              },
            ),
          ],
        );
      },
    );
  }
}
