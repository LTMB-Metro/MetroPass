import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/colors/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../book_ticket/book_ticket_page.dart';

class InstructionPage extends StatelessWidget {
  const InstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.pr1);
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);
    final secondaryColor =
        isDarkMode ? const Color(0xFF424242) : const Color(MyColor.pr3);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
          child: Container(
            height: 1,
            color: isDarkMode ? Colors.grey[800] : const Color(MyColor.pr8),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundColor, secondaryColor],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? Colors.grey[900] : Color(MyColor.white),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.bookTicket,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.help1,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isDarkMode
                                    ? Colors.grey[400]
                                    : Color(MyColor.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Steps Section
                  _buildStepSection(
                    context,
                    title: AppLocalizations.of(context)!.step1Title,
                    description: AppLocalizations.of(context)!.step1Description,
                    icon: Icons.confirmation_number,
                  ),
                  _buildStepSection(
                    context,
                    title: AppLocalizations.of(context)!.step2Title,
                    description: AppLocalizations.of(context)!.step2Description,
                    icon: Icons.payment,
                  ),
                  _buildStepSection(
                    context,
                    title: AppLocalizations.of(context)!.step3Title,
                    description: AppLocalizations.of(context)!.step3Description,
                    icon: Icons.check_circle,
                  ),

                  SizedBox(height: 24),

                  // Tips Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode
                              ? Colors.grey[900]
                              : Color(MyColor.pr7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isDarkMode ? Colors.grey[800]! : Color(MyColor.pr7),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color:
                                  isDarkMode
                                      ? Colors.amber
                                      : Color(MyColor.pr7),
                            ),
                            SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.proTips,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDarkMode
                                        ? Colors.amber
                                        : Color(MyColor.pr7),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        _buildTipItem(
                          context,
                          AppLocalizations.of(context)!.tip1,
                          Icons.schedule,
                        ),
                        _buildTipItem(
                          context,
                          AppLocalizations.of(context)!.tip2,
                          Icons.school,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode
                                ? Colors.transparent
                                : const Color(MyColor.pr8),
                        foregroundColor: isDarkMode ? textColor : Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                isDarkMode
                                    ? const Color(0xFF424242)
                                    : Colors.transparent,
                          ),
                        ),
                      ),
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BookTicketPage()),
                          ),
                      child: Text(
                        AppLocalizations.of(context)!.startBooking,
                        style: TextStyle(
                          color: isDarkMode ? textColor : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepSection(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);
    final secondaryColor =
        isDarkMode ? const Color(0xFF424242) : const Color(MyColor.pr8);
    final iconColor = isDarkMode ? Colors.white : const Color(MyColor.pr8);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Color(MyColor.white),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? const Color(0xFF424242)
                      : secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Color(MyColor.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String text, IconData icon) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);
    final iconColor = isDarkMode ? Colors.white : const Color(MyColor.pr7);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14, color: textColor)),
          ),
        ],
      ),
    );
  }
}
