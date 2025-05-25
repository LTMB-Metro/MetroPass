import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metropass/models/ticket_type_model.dart';
import 'package:metropass/themes/colors/colors.dart';

class TicketCardDialog extends StatelessWidget {
  final TicketTypeModel ticket;

  const TicketCardDialog({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final hsdTime = ticket.duration * 24;
    String hsd = hsdTime <= 72 ? '${hsdTime}h' : '${ticket.duration} ngày';
    hsd += ticket.type == 'single'
        ? ' kể từ ngày mua'
        : ' kể từ thời điểm kích hoạt';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: CustomPaint(
        painter: _TicketPainter(),
        size: const Size(341, 380),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Image.asset('assets/images/logo.png', height: 25)),
              const SizedBox(height: 20),
              _infoRow('Loại vé:', ticket.ticketName),
              _infoRow('HSD:', hsd),
              _infoRow('Lưu ý:', ticket.note, color: Color(MyColor.red)),
              if (ticket.description.isNotEmpty)
                _infoRow('Mô tả:', ticket.description),
              const SizedBox(height: 20),
              Divider(color: Color(MyColor.pr8), height: 1),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(MyColor.pr8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Mua ngay: ${NumberFormat('#,###', 'vi_VN').format(ticket.price)} đ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(MyColor.pr1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            child: Text(
              '$label ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: color ?? Color(MyColor.pr9),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 8,
            child: Text(
              value,
              style: TextStyle(
                color: color ?? Color(MyColor.pr8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFEFFFFB);
    final clearPaint = Paint()..blendMode = BlendMode.clear;

    // Draw main rounded box
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(20),
    );
    canvas.drawRRect(rrect, bgPaint);

    // Clear round holes left/right
    const double radius = 13;
    const double cy = 340; // adjust vertically
    canvas.drawCircle(Offset(0, cy), radius, clearPaint);
    canvas.drawCircle(Offset(size.width, cy), radius, clearPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
