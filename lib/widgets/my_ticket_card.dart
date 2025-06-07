import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metropass/models/user_ticket_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/ticket_qr_dialog.dart';

class MyTicketCard extends StatelessWidget {
  final UserTicketModel userTicket;
  final String userTicketStatus;
  const MyTicketCard({
    super.key,
    required this.userTicket,
    required this.userTicketStatus
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('HH:mm dd/MM/yyyy');
    late String showName;
    late String showHsd;
    if(userTicketStatus == 'unused'){
      if (userTicket.ticketType == 'single') {
        final DateTime activatedTime = userTicket.bookingTime.add(Duration(days: userTicket.duration));
        showHsd = 'Tự động kích hoạt vào ${formatter.format(activatedTime)}';
        showName = userTicket.description;
      } else {
        showName = userTicket.ticketName;
        showHsd = userTicket.note;
        if(userTicket.duration <30){
          final DateTime activatedTime = userTicket.bookingTime.add(Duration(days: userTicket.duration*30));
          showHsd = 'Tự động kích hoạt vào ${formatter.format(activatedTime)}';
        } else{
          final DateTime activatedTime = userTicket.bookingTime.add(Duration(days: 180));
          showHsd = 'Tự động kích hoạt vào ${formatter.format(activatedTime)}';
        }
      }
    }else{
      if (userTicket.ticketType == 'single') {
        showHsd = 'Vé sử dụng 1 lần';
        showName = userTicket.description;
      } else {
        showName = userTicket.ticketName;
        showHsd = userTicket.note;
        if(userTicket.activateTime != null){
          final DateTime activatedTime = userTicket.activateTime!.add(Duration(days: userTicket.duration*24));
          showHsd = 'Hết hiệu lúc vào lúc ${formatter.format(activatedTime)}';
        } else{
          showHsd = 'Chưa xác định';
        }
      }
    }
    
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => TicketQrDialog(
            userTicket: userTicket,
            userTicketStatus: userTicketStatus,
            showName: showName,
            showNote: showHsd,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: Color(MyColor.white),
          borderRadius: BorderRadius.circular(20),
          border: Border(
            left: BorderSide(
              width: 4,
              color: Color(MyColor.pr8)
            ),
            bottom: BorderSide(
              width: 1,
              color: Color(MyColor.pr8)
            )
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                showName, 
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(MyColor.pr9)
                ),
              ),
            ),
            const SizedBox(height: 5,),
            buildTitle('HSD: ', showHsd, Color(MyColor.red)),
            //buildTitle('Đơn giá: ', '${NumberFormat('#,###', 'vi_VN').format(userTicket.price)} đ'),
            //buildTitle('Lưu ý', showNote, Color(MyColor.red))
          ],
        ),
      ),
    );
  }
  Widget buildTitle(String title, String main, [Color? color]){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          // Expanded(
          //   flex: 3,
          //   child: Text(
          //     title,
          //     style: TextStyle(
          //       fontSize: 13,
          //       fontWeight: FontWeight.w500,
          //       color: color ?? Color(MyColor.pr9)
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 7,
            child: Text(
              main,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color?? Color(MyColor.pr8)
              ),
            ),
          ),
        ],
      ),
    );
  }
}