import 'package:flutter/material.dart';
import 'package:metropass/models/ticket_type_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  final TicketTypeModel Ticket;
  const TicketCard({
    super.key,
    required this.Ticket
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _showTicketDetailDialog(context);
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
                'assets/images/ticket.png',
              ),
            ),
            const SizedBox(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Ticket.ticketName,
                  style: TextStyle(
                    color: Color(MyColor.pr9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  '${NumberFormat('#,###', 'vi_VN').format(Ticket.price)} đ',
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
  void _showTicketDetailDialog(BuildContext context) {
    final hsd_time = Ticket.duration * 24;
    String? hsd;
    if(hsd_time <= 72){
      hsd = '${hsd_time}h';
    }else{
      hsd = '${Ticket.duration} ngày';
    }
    if(Ticket.type == 'single'){
      hsd = hsd + ' kể từ ngày mua';
    } else{
      hsd = hsd + ' kể từ thời diểm kích hoạt';
    }
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: SizedBox(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 341,
                  height: 348,
                  decoration: BoxDecoration(
                    color: const Color(MyColor.pr1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      Image.asset('assets/images/logo.png', height: 25),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow('Loại vé:', Ticket.ticketName),
                            _infoRow('HSD:', hsd!),
                            _infoRow(
                              'Lưu ý:',
                              Ticket.note,
                              color: Color(MyColor.red),
                            ),
                            if(Ticket.description != '')
                              _infoRow('Mô tả', Ticket.description)
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                //button
                Positioned(
                  top: 290,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(MyColor.pr8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: xử lý mua vé
                        },
                        child: Text(
                          'Mua ngay: ${NumberFormat('#,###', 'vi_VN').format(Ticket.price)} đ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(MyColor.pr1),
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 276,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: List.generate(
                      40,
                      (index) => Expanded(
                        child: Container(
                          height: 1,
                          color: index.isEven ? Color(MyColor.pr8) : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                // left
                Positioned(
                  left: -13,
                  top: 263,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 87, 103, 99),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                //right
                Positioned(
                  right: -13,
                  top: 263,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 87, 103, 99),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _infoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text('$label ', 
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: color ?? Color(MyColor.pr9)
              )),
          ),
          const SizedBox(width: 15,),
          Expanded(
            flex: 8,
            child: Text(
              value,
              style: TextStyle(
                color: color ?? Color(MyColor.pr8),
                fontSize: 14
              ),
            ),
          ),
        ],
      ),
    );
  }


}