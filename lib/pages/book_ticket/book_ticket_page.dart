import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metropass/widgets/route_list.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/ticket_hssv_list.dart';
import 'package:metropass/widgets/ticket_normal_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class BookTicketPage extends StatelessWidget {
  const BookTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);

    // AppBar colors
    final appBarBackgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.pr2);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor: appBarBackgroundColor,
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
        // Add bottom border for dark mode
        bottom:
            isDarkMode
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Container(color: Colors.grey[700], height: 1.0),
                )
                : null,
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : null,
          gradient:
              isDarkMode
                  ? null
                  : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(MyColor.pr1), Color(MyColor.pr3)],
                  ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // hello
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color:
                          isDarkMode
                              ? const Color(0xFF1E1E1E)
                              : const Color(MyColor.white),
                      border: Border.all(
                        color:
                            isDarkMode
                                ? Colors.grey[600]!
                                : const Color(MyColor.pr7),
                        width: isDarkMode ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream:
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Row(
                                children: [
                                  Shimmer.fromColors(
                                    baseColor:
                                        isDarkMode
                                            ? Colors.grey[700]!
                                            : Colors.grey[300]!,
                                    highlightColor:
                                        isDarkMode
                                            ? Colors.grey[500]!
                                            : Colors.grey[100]!,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color:
                                            isDarkMode
                                                ? Colors.grey[600]
                                                : Colors.grey[400],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Shimmer.fromColors(
                                    baseColor:
                                        isDarkMode
                                            ? Colors.grey[700]!
                                            : Colors.grey[300]!,
                                    highlightColor:
                                        isDarkMode
                                            ? Colors.grey[500]!
                                            : Colors.grey[100]!,
                                    child: Container(
                                      height: 16,
                                      width: 200,
                                      color:
                                          isDarkMode
                                              ? Colors.grey[600]
                                              : Colors.grey[400],
                                    ),
                                  ),
                                ],
                              );
                            }
                            final data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final name = data['username'] ?? 'Người dùng';
                            return Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    data['photoURL'],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.welcomeUser(name),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            );
                          },
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
