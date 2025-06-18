import 'package:flutter/material.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/my_ticket_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTicketPage extends StatelessWidget {
  const MyTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Color(MyColor.pr1);
    final textColor = isDarkMode ? Colors.white : Color(MyColor.pr9);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.myTicketsWithEmoji,
            style: TextStyle(color: textColor),
          ),
          centerTitle: true,
          backgroundColor: backgroundColor,
          iconTheme: IconThemeData(color: textColor),
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Color(MyColor.white),
                borderRadius: BorderRadius.circular(20),
                border:
                    isDarkMode
                        ? Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        )
                        : null,
              ),
              child: TabBar(
                padding: EdgeInsets.all(0),
                indicator: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Color(MyColor.pr4),
                  borderRadius: BorderRadius.circular(15),
                ),
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                labelColor: isDarkMode ? Colors.white : Colors.black,
                unselectedLabelColor:
                    isDarkMode ? Colors.grey[400] : Colors.black54,
                tabs: [
                  Tab(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        AppLocalizations.of(context)!.inUse,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Color(MyColor.pr9),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        AppLocalizations.of(context)!.unused,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Color(MyColor.pr9),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MyTicketList(userTicketStatus: 'used'),
                  MyTicketList(userTicketStatus: 'unused'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
