import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:metropass/controller/user_ticket_controller.dart';
import 'package:metropass/pages/my_ticket/expried_ticket_page.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/my_ticket_list.dart';

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
              title: const Text("Vé của tôi 🎫", style: TextStyle(color: Color(MyColor.pr9))),
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
                            "Đang sử dụng", 
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
                            "Chưa sử dụng", 
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
