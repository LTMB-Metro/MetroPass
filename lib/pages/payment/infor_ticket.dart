import 'package:flutter/material.dart';
import 'package:metropass/models/ticket_type_model.dart';
import 'package:metropass/themes/colors/colors.dart';

class InforTicket extends StatelessWidget {
  final TicketTypeModel ticket;
  const InforTicket({
    super.key, 
    required this.ticket
    });

  @override
  Widget build(BuildContext context) {
    final String name = ticket.type == 'single' ? 'Vé Lượt' : ticket.ticketName;
    final hsd = ticket.duration*24;
    final hsdNote = ticket.type == 'single' ? 'kể từ ngày mua' : 'kể từ thời điểm kích hoạt';
    String? showHsd;
    if(hsd <= 72){
      showHsd = '${hsd}h $hsdNote';
    }else{
      showHsd = '${ticket.duration} ngày $hsdNote';
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(MyColor.pr2),
      ),
      child: Column(
        children: [
          buildInfor('Loại vé:', name),
          buildInfor('HSD:', showHsd),
          buildInfor('Lưu ý:', ticket.note, color: Color(MyColor.red)),
          if(ticket.description !='') buildInfor('Mô tả:', ticket.description),
        ],
      ),
    );
  }

  Widget buildInfor(String label, String infor, {Color? color} ){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(
                  color: color?? Color(MyColor.pr8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                infor,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: color ?? Color(MyColor.black),
                  fontSize: 13,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } 
}