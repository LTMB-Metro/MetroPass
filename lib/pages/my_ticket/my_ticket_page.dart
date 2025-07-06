import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metropass/apps/router/router_name.dart';
import 'package:metropass/controllers/user_ticket_controller.dart';
import 'package:metropass/pages/home/home_page.dart';
import 'package:metropass/pages/my_ticket/expried_ticket_page.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/my_ticket_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTicketPage extends StatelessWidget {
  final int? tapIndex;
  const MyTicketPage({
    super.key,
    this.tapIndex,
  });

  Future<void> _checkAllTickets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await UserTicketController().checkAndUpdateAllAutoActivation(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Color(MyColor.pr1);
    final textColor = isDarkMode ? Colors.white : Color(MyColor.pr9);
    final initialIndex = tapIndex ?? 0;
    return FutureBuilder(
      future: _checkAllTickets(),
      builder: (context, snapshot) {
        return DefaultTabController(
          length: 2,
          initialIndex: initialIndex,
          child: Scaffold(
            backgroundColor: Color(MyColor.pr1),
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: textColor),
                onPressed: () {
                  context.go('/home');
                },
              ),
              title: Text(
                AppLocalizations.of(context)!.myTicketsWithEmoji, 
                style: TextStyle(color: Color(MyColor.pr9))),
              centerTitle: true,
              backgroundColor: Color(MyColor.pr1),
              elevation: 0,
              actions: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const ExpriedTicketPage()
                    )
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Hết hạn',
                      style: TextStyle(
                        color: Color(MyColor.pr8),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Color(MyColor.white),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: TabBar(
                    padding: EdgeInsets.all(0),
                    indicator: BoxDecoration(
                      color: Color(MyColor.pr4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    indicatorColor: Colors.transparent,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      Tab(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            AppLocalizations.of(context)!.inUse, 
                            style: TextStyle(
                              color: Color(MyColor.pr9),
                              fontWeight: FontWeight.bold,
                              fontSize: 14
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
                              color: Color(MyColor.pr9),
                              fontWeight: FontWeight.bold,
                              fontSize: 14
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
                      MyTicketList(userTicketStatus: 'active'),
                      MyTicketList(userTicketStatus: 'unused'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
