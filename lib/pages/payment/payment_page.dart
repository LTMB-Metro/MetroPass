import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:metropass/controller/payment_method_controller.dart';
import 'package:metropass/controller/user_ticket_controller.dart';
import 'package:metropass/models/payment_method_model.dart';
import 'package:metropass/models/ticket_type_model.dart';
import 'package:metropass/pages/payment/infor_payment.dart';
import 'package:metropass/pages/payment/infor_ticket.dart';
import 'package:metropass/pages/payment/vnpay_webview_page.dart';
import 'package:metropass/services/vnpay_payment_service.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/skeleton/station_card_skeleton.dart';

class PaymentPage extends StatefulWidget {
  final TicketTypeModel ticket;
  const PaymentPage({
    super.key,
    required this.ticket
    });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool showPaymentMethor = false;
  String selectedMethod = 'Phương thức thanh toán';
  Widget logoSelectedMethod = SvgPicture.asset('assets/icons/credit_card.svg', fit: BoxFit.fill,);
  final PaymentMethodController _controller = PaymentMethodController();
  List<PaymentMethodModel> paymentMethods = [];
  bool isLoadingPayment = true;
  final UserTicketController _userTicketController = UserTicketController();
  @override
  void initState() {
    super.initState();
    loadPaymentMethods();
  }
  Future<void> loadPaymentMethods() async {
    final data = await _controller.getPaymentMethod();
    setState(() {
      paymentMethods = data;
      isLoadingPayment = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back)
        ),
        title: Text(
          'Thông tin đơn hàng', 
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(MyColor.pr9)
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), 
          child: Container(
            height: 1,
            color: Color(MyColor.pr8),
          )
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top:  20, bottom: 5),
                  child: Text(
                    'Phương thức thanh toán',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(MyColor.pr9)
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left:  10, right: 5, top:  10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(MyColor.pr2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(MyColor.pr7)
                    )
                  ),
                  child: Column(
                    children: [
                      paymentMethod(logoSelectedMethod, selectedMethod),
                      if(showPaymentMethor) paymentMethodList(),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:  20),
                  child: Text(
                    'Thông tin thanh toán',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(MyColor.pr9)
                    ),
                  ),
                ),
                InforPayment(ticket: widget.ticket),
                Container(
                  padding: EdgeInsets.only(top:  10),
                  child: Text(
                    'Thông tin vé',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(MyColor.pr9)
                    ),
                  ),
                ),
                InforTicket(ticket: widget.ticket),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 60,)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(35,0,35,25),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedMethod == 'Phương thức thanh toán'? Color(MyColor.grey) : Color(MyColor.pr8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (selectedMethod == 'Phương thức thanh toán') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Vui lòng chọn phương thức thanh toán")),
                );
                return;
              }
              await _userTicketController.createUserTicket(widget.ticket);
            //   print("🚀 Gọi hàm tạo link thanh toán...");
            //   final url = await createVNPayPayment(widget.ticket.price);
            //   if (!context.mounted) return;
            //   if (url != null) {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => VNPayWebViewPage(
            //           paymentUrl: url,
            //           onPaymentComplete: (bool success) async {
            //             final message = success
            //                 ? 'Thanh toán thành công!'
            //                 : 'Thanh toán thất bại hoặc bị huỷ';
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(content: Text(message)),
            //             );
            //             if(success) await _userTicketController.createUserTicket(widget.ticket);
            //           },
            //         ),
            //       ),
            //     );
            //   } else {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text("Không tạo được link thanh toán")),
            //     );
            //   }
            },
            child: Text(
              'Thanh toán: ${NumberFormat('#,###', 'vi_VN').format(widget.ticket.price)} đ',
              style: TextStyle(
                fontSize: 16,
                color: Color(MyColor.pr1),
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget paymentMethod(Widget image, String title){
    return GestureDetector(
      onTap: (){
        setState(() {
          showPaymentMethor = !showPaymentMethor;
        });
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 5, top: 5),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 22,
                  height: 18,
                  child: image,
                ),
              )
            ),
            const SizedBox(width: 5,),
            Expanded(
              flex: 8,
              child: Text(
                title,
                style: TextStyle(
                  color: Color(MyColor.pr9),
                  fontSize: 14
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: showPaymentMethor ? Icon(Icons.keyboard_arrow_down, size: 23,) : Icon(Icons.arrow_forward_ios_rounded, size: 16,),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget showPayment(Widget image, String title, String status){
    final String checkStatus = 'active';
    return GestureDetector(
      onTap: (){
        status == checkStatus ?
        setState(() {
          showPaymentMethor = !showPaymentMethor;
          selectedMethod = title;
          logoSelectedMethod = image;
        }): 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Phương thức thanh toán này chưa hỗ trợ')),
          );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(left: 15, top: 5, bottom: 5 ),
        decoration: BoxDecoration(
          color: status == checkStatus ? Color(MyColor.white) : Colors.grey[300],
          border: Border(
            left: BorderSide(
              color: Color(MyColor.pr8),
              width: 3
            ),
            bottom: BorderSide(
              color: Color(MyColor.pr8),
              width: 0.5
            )
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 22,
                  height: 18,
                  child: image,
                ),
              )
            ),
            const SizedBox(width: 5,),
            Expanded(
              flex: 8,
              child: Text(
                title,
                style: TextStyle(
                  color: Color(MyColor.pr9),
                  fontSize: 14
                ),
              ),
            ),
            status == checkStatus ?
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Checkbox(
                value: selectedMethod == title,
                onChanged: (_) {},
                shape: const CircleBorder(),
                checkColor: Colors.white,
                activeColor: Colors.green,
              )
              )
            ) : Container(height: 45,),
          ],
        ),
      ),
    );
  }
  Widget paymentMethodList(){
    if (isLoadingPayment) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, index) => const StationCardSkeleton(),
      );
    }
    if (paymentMethods.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có phương thức nào được hỗ trợ',
          style: TextStyle(
            color: Color(MyColor.pr9),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paymentMethods.length,
      itemBuilder: (context, index) {
        final method = paymentMethods[index];
        return showPayment(Image.network(method.logoUrl), method.name, method.status);
      },
    );
  }
}