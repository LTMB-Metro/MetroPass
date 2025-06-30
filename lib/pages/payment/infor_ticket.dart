import 'package:flutter/material.dart';
import 'package:metropass/models/ticket_type_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InforTicket extends StatelessWidget {
  final TicketTypeModel ticket;
  const InforTicket({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDarkMode ? const Color(0xFF1E1E1E) : const Color(MyColor.pr2);

    final String name =
        ticket.type == 'single'
            ? AppLocalizations.of(context)!.singleTicket
            : ticket.ticketName;
    final hsd = ticket.duration * 24;
    final hsdNote =
        ticket.type == 'single'
            ? AppLocalizations.of(context)!.fromPurchaseDate
            : AppLocalizations.of(context)!.fromActivationTime;
    String? showHsd;
    if (hsd <= 72) {
      showHsd = '${hsd}h $hsdNote';
    } else {
      showHsd =
          '${ticket.duration} ${AppLocalizations.of(context)!.days} $hsdNote';
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cardColor,
      ),
      child: Column(
        children: [
          buildInfor(AppLocalizations.of(context)!.ticketType, name),
          buildInfor(AppLocalizations.of(context)!.expiryLabel, showHsd),
          buildInfor(
            AppLocalizations.of(context)!.note,
            ticket.note,
            color: const Color(MyColor.red),
          ),
          if (ticket.description != '')
            buildInfor(
              '${AppLocalizations.of(context)!.description}',
              ticket.description,
            ),
        ],
      ),
    );
  }

  Widget buildInfor(String label, String infor, {Color? color}) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final labelColor =
            isDarkMode ? Colors.white70 : const Color(MyColor.pr8);
        final defaultValueColor =
            isDarkMode ? Colors.white : const Color(MyColor.black);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color ?? labelColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    infor,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: color ?? defaultValueColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
