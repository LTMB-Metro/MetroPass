import 'package:flutter/material.dart';
import 'package:metropass/controllers/user_ticket_controller.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/my_ticket_card.dart';
import 'package:metropass/widgets/skeleton/user_ticket_card_skeleton.dart';

class MyTicketList extends StatelessWidget {
  final String userTicketStatus;
  MyTicketList({super.key, required this.userTicketStatus});
  final UserTicketController _controller = UserTicketController();
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Color(MyColor.pr9);

    return StreamBuilder(
      stream: _controller.getTicketsByStatus(userTicketStatus),
      builder: (context, snapshot) {
        // Kiểm tra lỗi
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Đã có lỗi xảy ra',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        // Kiểm tra trạng thái loading
        if (!snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1, // Chỉ hiển thị 1 skeleton khi loading
            itemBuilder:
                (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: UserTicketCardSkeleton(),
                ),
          );
        }

        // Kiểm tra danh sách rỗng
        if (snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Không có vé nào',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        // Hiển thị danh sách vé
        final userTicket = snapshot.data!.toList();
        return ListView.separated(
          itemBuilder:
              (context, index) => MyTicketCard(
                userTicket: userTicket[index],
                userTicketStatus: userTicketStatus,
              ),
          separatorBuilder: (_, __) => const SizedBox(height: 0),
          itemCount: userTicket.length,
        );
      },
    );
  }
}
