import 'package:flutter/material.dart';
import 'package:metropass/themes/colors/colors.dart';

class InfomationPage extends StatelessWidget {
  const InfomationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(MyColor.pr2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(MyColor.pr9)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bảng giá vé Metro Bến Thành - Suối Tiên',
          style: TextStyle(color: Color(MyColor.pr9), fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Color(MyColor.pr9), fontSize: 15),
                children: [
                  TextSpan(
                    text:
                        'Bảng giá vé tuyến Metro số 1 Bến Thành - Suối Tiên\n',
                  ),
                  WidgetSpan(
                    child: Icon(
                      Icons.star,
                      color: Color(MyColor.red),
                      size: 16,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' Học sinh, sinh viên được giảm 50%, chỉ còn 150.000 đồng/tháng',
                    style: TextStyle(color: Color(MyColor.red)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset(
                  'assets/images/calendar.png',
                  width: 18,
                  height: 18,
                  color: const Color(MyColor.pr8),
                ),
                const SizedBox(width: 6),
                const Text(
                  '16/12/2024 12:00:00',
                  style: TextStyle(fontSize: 14, color: Color(MyColor.pr9)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '"Ban hành giá vé dịch vụ vận tải bằng Metro số 1"\nKhi hành khách sử dụng Metro số 1:',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Thanh toán không dùng tiền mặt chỉ từ 6 nghìn đồng'),
                  Text('• Thanh toán tiền mặt chỉ từ 7 nghìn đồng.'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset(
                  'assets/images/notification.png',
                  width: 18,
                  height: 18,
                  color: const Color(MyColor.pr8),
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Với mục tiêu phù hợp với khả năng chi trả của người dân, đảm bảo thuận tiện cho di chuyển',
                    style: TextStyle(fontSize: 14, color: Color(MyColor.pr9)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/station.png',
                  width: 18,
                  height: 18,
                  color: Color(MyColor.pr8),
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Định giá giúp người dân dễ dàng tiếp cận phương tiện công cộng hiện đại. Khuyến khích thói quen sử dụng giao thông công cộng, góp phần giảm ùn tắc giao thông đô thị và giảm thiểu ô nhiễm môi trường. HƯỚNG tới xây dựng hệ thống giao thông vận tải công cộng hiện đại, văn minh.',
                    style: TextStyle(fontSize: 14, color: Color(MyColor.pr9)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/station.png',
                  width: 18,
                  height: 18,
                  color: Color(MyColor.pr8),
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Ngoài ra, giá vé được xây dựng linh hoạt theo chặng và vé ngày/vé tháng nhằm khuyến khích di chuyển nhiều hơn với mức chi phí hợp lý hơn.',
                    style: TextStyle(fontSize: 14, color: Color(MyColor.pr9)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
