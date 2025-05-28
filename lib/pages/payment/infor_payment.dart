import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metropass/controller/get_station_controller.dart';
import 'package:metropass/models/ticket_type_model.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/skeleton/ticket_card_skeleton.dart';

class InforPayment extends StatefulWidget {
  final TicketTypeModel ticket;
  const InforPayment({
    super.key,
    required this.ticket
    });

  @override
  State<InforPayment> createState() => _InforPaymentState();
}

class _InforPaymentState extends State<InforPayment> {
  late final Future<String> _productNameFuture;

  @override
  void initState() {
    super.initState();
    _productNameFuture = _getProductName();
  }

  Future<String> _getProductName() async {
    if (widget.ticket.type != 'single') {
      return widget.ticket.ticketName;
    } else {
      final from = await GetStationController(ticketCode: widget.ticket.fromCode).getStationByCode();
      final to = await GetStationController(ticketCode: widget.ticket.toCode).getStationByCode();
      return 'Vé lượt: $from - $to';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String price = '${NumberFormat('#,###', 'vi_VN').format(widget.ticket.price)} đ';

    return FutureBuilder<String>(
      future: _productNameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) => const TicketCardSkeleton(),
          );
        }

        final name = snapshot.data ?? 'Không rõ';

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(MyColor.pr2),
          ),
          child: Column(
            children: [
              buildInfor('Sản phẩm', name),
              buildInfor('Đơn giá:', price),
              buildInfor('Số lượng:', '1'),
              Container(
                height: 0.5,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(MyColor.pr8)
                ),
              ),
              const SizedBox(height: 1,),
              Container(
                height: 0.5,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(MyColor.pr8)
                ),
              ),
              const SizedBox(height: 10),
              buildInfor('Thành tiền:', price, color: Color(MyColor.pr8)),
            ],
          ),
        );
      },
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
                  color: Color(MyColor.pr8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                infor,
                textAlign: TextAlign.right,
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