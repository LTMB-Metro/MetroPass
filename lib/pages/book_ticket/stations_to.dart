import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metropass/models/station_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/ticket_single.dart';

class StationsTo extends StatelessWidget {
  final StationModel station;
  const StationsTo({
    super.key,
    required this.station
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
          'Vé lượt - Đi từ ga ${station.stationName}', 
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
                TicketSingle(station: station),
                const SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}