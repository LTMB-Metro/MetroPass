import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metropass/models/station_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/ticket_single.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StationsTo extends StatelessWidget {
  final StationModel station;
  const StationsTo({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.pr1);
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);

    return Scaffold(
      backgroundColor: backgroundColor,
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
          '${AppLocalizations.of(context)!.singleTicket} - ${AppLocalizations.of(context)!.stationFrom} ${station.stationName}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDarkMode ? Colors.grey[500] : Color(MyColor.pr8),
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
                children: [
                  TicketSingle(station: station),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
