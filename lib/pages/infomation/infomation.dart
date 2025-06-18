import 'package:flutter/material.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // AppBar colors
    final appBarBackgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.pr2);

    // Body background colors
    final bodyBackgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.white);

    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);

    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.metroLine1PriceTitle,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        centerTitle: true,
        // Add bottom border for dark mode
        bottom:
            isDarkMode
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Container(color: Colors.grey[700], height: 1.0),
                )
                : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price information with student discount highlight
            RichText(
              text: TextSpan(
                style: TextStyle(color: textColor, fontSize: 15),
                children: [
                  TextSpan(text: AppLocalizations.of(context)!.metroLine1Price),
                  WidgetSpan(
                    child: Icon(
                      Icons.star,
                      color: Color(MyColor.red),
                      size: 16,
                    ),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.studentDiscountInfo,
                    style: TextStyle(color: Color(MyColor.red)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Price update date information
            Row(
              children: [
                Image.asset(
                  'assets/images/calendar.png',
                  width: 18,
                  height: 18,
                  color: textColor,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context)!.priceUpdateDate,
                  style: TextStyle(fontSize: 14, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Price update details
            Text(
              AppLocalizations.of(context)!.priceUpdateTitle,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            // Payment method information
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.cashlessPaymentInfo,
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    AppLocalizations.of(context)!.cashPaymentInfo,
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Price goal information
            Row(
              children: [
                Image.asset(
                  'assets/images/notification.png',
                  width: 18,
                  height: 18,
                  color: textColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.priceGoal,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Price benefits information
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/station.png',
                  width: 18,
                  height: 18,
                  color: textColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.priceBenefit,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Price flexibility information
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/station.png',
                  width: 18,
                  height: 18,
                  color: textColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.priceFlexibility,
                    style: TextStyle(fontSize: 14, color: textColor),
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
