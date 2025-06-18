import 'package:flutter/material.dart';
import 'package:metropass/controllers/station_controller.dart';
import 'package:metropass/models/route_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/skeleton/station_card_skeleton.dart';
import 'package:metropass/widgets/station_card.dart';

class StationList extends StatelessWidget {
  final RouteModel route;
  StationList({
    super.key,
    required this.route
  });

  final StationController _controller = StationController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller.getStations(), 
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting ){
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 7,
            itemBuilder: (context, index) => const StationCardSkeleton()
          );
        }
        if(!snapshot.hasData || snapshot.data!.isEmpty){
          return const Center(
            child: Text(
              'Không có ga nào',
              style: TextStyle(
                color: Color(MyColor.pr9),
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          );
        }
        final stationCard = snapshot.data!
          .where((station) => station.zone == route.zone)
          .toList();
        if(stationCard.isEmpty){
          return Center(
            child: Text(
              '${route.name} hiện chưa có ga nào hoạt động',
              style: TextStyle(
                color: Color(MyColor.pr8),
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, _) => const SizedBox(height: 10,), 
          itemCount: stationCard.length,
          itemBuilder: (context, index) => StationCard(station: stationCard[index]), 
        );
      }
    );
  }
}