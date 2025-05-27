import 'package:flutter/material.dart';
import 'package:metropass/controller/route_controller.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/route_cart.dart';
import 'package:metropass/widgets/skeleton/ticket_card_skeleton.dart';

class RouteList extends StatelessWidget {
  RouteList({super.key});

  final RouteController _controller = RouteController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller.getRoute(), 
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) => const TicketCardSkeleton(),
          );
        }
        if(!snapshot.hasData || snapshot.data!.isEmpty){
          return const Center(
            child: Text(
              'Không có tuyến nào',
              style: TextStyle(
                color: Color(MyColor.pr9),
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          );
        }
        final route = snapshot.data!.toList();
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => RouteCart(route: route[index]), 
          separatorBuilder: (_, _) => const SizedBox(height: 10,), 
          itemCount: route.length
        );
      }
    );
  }
}