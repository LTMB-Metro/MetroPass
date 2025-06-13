import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:metropass/models/user_ticket_model.dart';

class TicketQrDialog extends StatelessWidget {
  final UserTicketModel userTicket;
  final String userTicketStatus;
  final String showName;
  final String showNote;
  final bool? showQr;
  const TicketQrDialog({
    super.key,
    required this.userTicket,
    required this.userTicketStatus,
    required this.showName,
    required this.showNote,
    this.showQr = true,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('HH:mm dd/MM/yyyy');
    final qrContent = '${userTicket.qrCodeContent}|${userTicket.userId}';

    final infoTab = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTitle('Loại vé: ', showName),
          buildTitle('Trạng thái: ', showQr == true 
          ? (userTicketStatus == 'unused' 
            ? 'Chưa sử dụng' 
            : 'Đang sử dụng') 
          : 'Đã hết hạn'),
          buildTitle('Giá: ', '${NumberFormat('#,###', 'vi_VN').format(userTicket.price)} đ'),
          userTicketStatus == 'active'
              ? buildTitle('Kích hoạt lúc: ', userTicket.activateTime == null ? 'Chưa xác định' : formatter.format(userTicket.activateTime!))
              : buildTitle('Đặt lúc', formatter.format(userTicket.bookingTime)),
          buildTitle('Lưu ý', showNote, Color(MyColor.red))
        ],
      ),
    );

    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      content: SizedBox(
        width: 300,
        height: 320,
        child: DefaultTabController(
          length: showQr == true ? 2 : 1,
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 70,
              ),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(MyColor.white),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TabBar(
                  padding: EdgeInsets.all(0),
                  indicator: BoxDecoration(
                    color: Color(MyColor.pr4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  tabs: showQr == true
                    ? [
                        Tab(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Mã QR", 
                              style: TextStyle(
                                color: Color(MyColor.pr9),
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Thông tin", 
                              style: TextStyle(
                                color: Color(MyColor.pr9),
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                              ),
                            ),
                          ),
                        ),
                      ]
                    : [
                        Tab(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Thông tin", 
                              style: TextStyle(
                                color: Color(MyColor.pr9),
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                              ),
                            ),
                          ),
                        ),
                      ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: showQr == true
                    ? [
                        // Tab 1: QR
                        Center(
                          child: QrImageView(
                            data: qrContent,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ),
                        // Tab 2: Info
                        infoTab,
                      ]
                    : [
                        infoTab,
                      ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Đóng", style: TextStyle(fontWeight: FontWeight.bold, color: Color(MyColor.pr9)),),
        ),
      ],
    );
  }
  Widget buildTitle(String title, String main, [Color? color]){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color ?? Color(MyColor.pr9)
              ),
            ),
          ),
          Expanded(
            flex: 6,
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
