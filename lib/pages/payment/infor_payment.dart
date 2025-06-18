import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metropass/controllers/get_station_controller.dart';
import 'package:metropass/models/ticket_type_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/skeleton/ticket_card_skeleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InforPayment extends StatefulWidget {
  final TicketTypeModel ticket;
  const InforPayment({super.key, required this.ticket});

  @override
  State<InforPayment> createState() => _InforPaymentState();
}

class _InforPaymentState extends State<InforPayment> {
  late final Future<String> _productNameFuture;

  @override
  void initState() {
    super.initState();
    _productNameFuture = _getProductName();
  }

  Future<String> _getProductName() async {
    if (widget.ticket.type != 'single') {
      return widget.ticket.ticketName;
    } else {
      final from =
          await GetStationController(
            ticketCode: widget.ticket.fromCode,
          ).getStationByCode();
      final to =
          await GetStationController(
            ticketCode: widget.ticket.toCode,
          ).getStationByCode();
      return '${AppLocalizations.of(context)!.singleTicket}: $from - $to';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDarkMode ? const Color(0xFF1E1E1E) : const Color(MyColor.pr2);
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr8);
    final valueColor = isDarkMode ? Colors.white70 : const Color(MyColor.black);

    final String price =
        '${NumberFormat('#,###', 'vi_VN').format(widget.ticket.price)} đ';

    return FutureBuilder<String>(
      future: _productNameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) => const TicketCardSkeleton(),
          );
        }

        final name = snapshot.data ?? AppLocalizations.of(context)!.unknown;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cardColor,
          ),
          child: Column(
            children: [
              buildInfor(AppLocalizations.of(context)!.productLabel, name),
              buildInfor(AppLocalizations.of(context)!.unitPrice, price),
              buildInfor(AppLocalizations.of(context)!.quantity, '1'),
              Container(
                height: 0.5,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: textColor),
              ),
              const SizedBox(height: 1),
              Container(
                height: 0.5,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: textColor),
              ),
              const SizedBox(height: 10),
              buildInfor(
                AppLocalizations.of(context)!.totalAmount,
                price,
                color: textColor,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildInfor(String label, String infor, {Color? color}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDarkMode ? Colors.white70 : const Color(MyColor.pr8);
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
              alignment: Alignment.centerRight,
              child: Text(
                infor,
                textAlign: TextAlign.right,
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
  }
}
