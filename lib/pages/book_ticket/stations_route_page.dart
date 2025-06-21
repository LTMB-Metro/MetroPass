import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metropass/models/route_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/station_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StationsRoutePage extends StatelessWidget {
  final RouteModel route;
  const StationsRoutePage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);
    
    // AppBar colors
    final appBarBackgroundColor = isDarkMode 
        ? Colors.black 
        : const Color(MyColor.pr2);

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
          route.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        // Add bottom border for dark mode
        bottom: isDarkMode ? PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[700],
            height: 1.0,
          ),
        ) : null,
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : null,
          gradient: isDarkMode
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
                children: [
                  StationList(route: route),
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
