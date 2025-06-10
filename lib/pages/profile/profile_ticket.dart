import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../themes/colors/colors.dart';
import '../../apps/router/router_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileTicketPage extends StatelessWidget {
  const ProfileTicketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColor.pr2),
      appBar: AppBar(
        backgroundColor: const Color(MyColor.pr2),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(MyColor.pr9)),
          onPressed: () => context.goNamed(RouterName.profile),
        ),
        title: Text(
          AppLocalizations.of(context)!.myTickets,
          style: const TextStyle(
            color: Color(MyColor.pr9),
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(MyColor.pr8)),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Container(
                width: 400,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: const Color(MyColor.white),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(MyColor.grey),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child:  Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.ticketAvailable,
                                    style: TextStyle(
                                      color: Color(MyColor.white),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.ticketUsed,
                                style: TextStyle(
                                  color: Color(MyColor.pr9),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    // Ticket cards
                    _TicketCard(
                      title: AppLocalizations.of(context)!.dayTicket,
                      date: '14/12/2025',
                      price: '40.000 VND',
                      status: AppLocalizations.of(context)!.ticketAvailable,
                      borderColor: Color(MyColor.pr7),
                    ),
                    const SizedBox(height: 18),
                    _TicketCard(
                      title: AppLocalizations.of(context)!.monthTicket,
                      date: '08/6/2025',
                      price: '300.000 VND',
                      status: AppLocalizations.of(context)!.ticketAvailable,
                      borderColor: Color(MyColor.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Button
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor: const Color(MyColor.pr8),
                  onPressed: () {},
                  child: const Icon(Icons.add, color: Color(MyColor.white)),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.buyNewTicket,
                  style: const TextStyle(
                    color: Color(MyColor.pr8),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final String title;
  final String date;
  final String price;
  final String status;
  final Color borderColor;
  const _TicketCard({
    required this.title,
    required this.date,
    required this.price,
    required this.status,
    required this.borderColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(MyColor.pr1),
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: borderColor, width: 5)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(MyColor.pr9),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  AppLocalizations.of(context)!.expiryDate,
                  style: TextStyle(color: Color(MyColor.grey), fontSize: 16),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(MyColor.pr9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Text(
                  AppLocalizations.of(context)!.ticketPrice,
                  style: TextStyle(color: Color(MyColor.grey), fontSize: 16),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    color: Color(MyColor.pr9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  AppLocalizations.of(context)!.status,
                  style: TextStyle(color: Color(MyColor.grey), fontSize: 16),
                ),
                Text(
                  status,
                  style: const TextStyle(
                    color: Color(MyColor.pr9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
