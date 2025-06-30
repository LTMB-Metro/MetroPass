import 'package:flutter/material.dart';
import 'package:metropass/models/station_model.dart';
import 'package:metropass/pages/book_ticket/stations_to.dart';
import 'package:metropass/themes/colors/colors.dart';

class StationCard extends StatelessWidget {
  final StationModel station;
  const StationCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final stationTextColor = isDarkMode ? Colors.white : Color(MyColor.pr9);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(
              'Đi từ ga ${station.stationName}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: stationTextColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StationsTo(station: station),
                  ),
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Xem chi tiết',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(MyColor.pr8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
