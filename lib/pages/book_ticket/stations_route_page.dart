import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metropass/models/route_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/station_list.dart';

class StationsRoutePage extends StatelessWidget {
  final RouteModel route;
  const StationsRoutePage({
    super.key,
    required this.route
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back)
        ),
        title: Text(
          route.name, 
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(MyColor.pr9)
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), 
          child: Container(
            height: 1,
            color: Color(MyColor.pr8),
          )
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 17, vertical: 11),
            child: Column(
              children: [
                StationList(route: route),
                const SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}