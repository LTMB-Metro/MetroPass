import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metropass/pages/book_ticket/book_ticket_page.dart';
import 'package:metropass/pages/welcome/welcome_page.dart';
import 'package:metropass/pages/profile/profile.dart';
import 'package:metropass/pages/infomation/infomation.dart';
import 'package:metropass/pages/instruction/instruction_page.dart';
import 'package:metropass/route_information/route_information.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:metropass/apps/router/router_name.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.black);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        extendBody: true,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 376,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/metromap.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          buildhelp(
                            context,
                            AssetImage('assets/images/help.png'),
                            AppLocalizations.of(context)!.help1,
                            InstructionPage(),
                          ),
                          buildhelp(
                            context,
                            AssetImage('assets/images/help2.png'),
                            AppLocalizations.of(context)!.help2,
                            RouteInformationPage(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              Positioned(
                top: 312,
                left: 17,
                right: 17,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Color(MyColor.pr1),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        Image.asset(
                          'assets/images/logo.png',
                          width: 79,
                          height: 25,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: buildIcon(
                                context,
                                Image.asset('assets/images/ticket1.png'),
                                AppLocalizations.of(context)!.bookTicket,
                                BookTicketPage(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: buildIcon(
                                context,
                                Image.asset('assets/images/ticket2.png'),
                                AppLocalizations.of(context)!.myTickets,
                                WelcomePage(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: buildIcon(
                                context,
                                Image.asset('assets/images/ticket3.png'),
                                AppLocalizations.of(context)!.info,
                                InformationPage(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: buildIcon(
                                context,
                                Image.asset('assets/images/map1.png'),
                                AppLocalizations.of(context)!.routes,
                                () => context.pushNamed(
                                  RouterName.routeInformation,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: buildIcon(
                                context,
                                Image.asset('assets/images/map2.png'),
                                AppLocalizations.of(context)!.map,
                                WelcomePage(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: buildIcon(
                                context,
                                Image.asset('assets/images/profile.png'),
                                AppLocalizations.of(context)!.account,
                                ProfilePage(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIcon(
    BuildContext context,
    Image image,
    String lable,
    dynamic onTap,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.black);

    return GestureDetector(
      onTap:
          onTap is Widget
              ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => onTap),
                );
              }
              : onTap,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Color(MyColor.pr3),
              borderRadius: BorderRadius.circular(50),
            ),
            child: image,
          ),
          const SizedBox(height: 4),
          Text(lable, style: TextStyle(fontSize: 14, color: textColor)),
        ],
      ),
    );
  }

  Widget buildhelp(
    BuildContext context,
    ImageProvider image,
    String lable,
    Widget targetpage,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.black);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => targetpage));
      },
      child: Container(
        width: 302,
        height: 220,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 0.1),
            ),
          ],
          color: isDarkMode ? Colors.black : Color(MyColor.white),
        ),
        child: Column(
          children: [
            Container(
              height: 154,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image: image, fit: BoxFit.cover),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lable,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.seeNow,
                    style: TextStyle(
                      color:
                          isDarkMode ? Colors.grey[400] : Color(MyColor.grey),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
