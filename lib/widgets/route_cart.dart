import 'package:flutter/material.dart';
import 'package:metropass/models/route_model.dart';
import 'package:metropass/pages/book_ticket/stations_route_page.dart';
import 'package:metropass/themes/colors/colors.dart';

class RouteCart extends StatelessWidget {
  final RouteModel route;
  const RouteCart({
    super.key,
    required this.route
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
       Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (_) => StationsRoutePage(route: route))
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Color(MyColor.white),
          border: Border.all(
            color: Color(MyColor.pr7),
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(MyColor.pr3)
              ),
              child: Image.asset(
                'assets/images/station.png',
              ),
            ),
            const SizedBox(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route.name,
                  style: TextStyle(
                    color: Color(MyColor.pr9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  '${route.from} - ${route.to}',
                  style: TextStyle(
                    color: Color(MyColor.pr8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}