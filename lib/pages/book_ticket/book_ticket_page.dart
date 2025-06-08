import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metropass/widgets/route_list.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/ticket_hssv_list.dart';
import 'package:metropass/widgets/ticket_normal_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookTicketPage extends StatelessWidget {
  const BookTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.pr2);
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: textColor),
        ),
        title: Text(
          AppLocalizations.of(context)!.bookTicket,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        actions: [
          Image.asset('assets/images/logo.png', width: 80, height: 25),
          const SizedBox(width: 10),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(height: 1, color: Color(MyColor.pr8)),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [Colors.black, Colors.black]
                    : [Color(MyColor.pr1), Color(MyColor.pr3)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 17, vertical: 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // hello
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color:
                          isDarkMode ? Colors.grey[900] : Color(MyColor.white),
                      border: Border.all(
                        color:
                            isDarkMode ? Colors.grey[800]! : Color(MyColor.pr7),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/avt.png'),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.welcomeUser('Nguyễn Như Phương'),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // love
                  const SizedBox(height: 20),
                  Text(
                    '💞 ${AppLocalizations.of(context)!.favorite} 💞',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  TicketNormalList(),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.studentDiscount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  TicketHssvList(),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.routes,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  RouteList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
