import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:metropass/apps/router/router_name.dart';
import 'package:metropass/controllers/user_ticket_controller.dart';
import 'package:metropass/controllers/payment_method_controller.dart';
import 'package:metropass/models/payment_method_model.dart';
import 'package:metropass/models/ticket_type_model.dart';
import 'package:metropass/pages/payment/infor_payment.dart';
import 'package:metropass/pages/payment/infor_ticket.dart';
import 'package:metropass/pages/payment/vnpay_webview_page.dart';
import 'package:metropass/services/vnpay_payment_service.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:metropass/widgets/skeleton/station_card_skeleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentPage extends StatefulWidget {
  final TicketTypeModel ticket;
  const PaymentPage({super.key, required this.ticket});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool showPaymentMethor = false;
  String selectedMethod = '';
  Widget logoSelectedMethod = SvgPicture.asset(
    'assets/icons/credit_card.svg',
    fit: BoxFit.fill,
  );
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final appBarBackgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.pr2);
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);
    final cardColor =
        isDarkMode ? const Color(0xFF1E1E1E) : const Color(MyColor.pr2);
    final borderColor =
        isDarkMode ? Colors.grey[600]! : const Color(MyColor.pr7);

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: AppBar(
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor: appBarBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: textColor),
        ),
        title: Text(
          AppLocalizations.of(context)!.orderInformation,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        // Add bottom border for dark mode
        bottom:
            isDarkMode
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Container(color: Colors.grey[700], height: 1.0),
                )
                : PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(height: 1, color: const Color(MyColor.pr8)),
                ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 5),
                  child: Text(
                    AppLocalizations.of(context)!.paymentMethod,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 5,
                    top: 10,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      paymentMethod(
                        logoSelectedMethod,
                        selectedMethod.isEmpty
                            ? AppLocalizations.of(context)!.paymentMethod
                            : selectedMethod,
                      ),
                      if (showPaymentMethor) paymentMethodList(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    AppLocalizations.of(context)!.paymentInformation,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                InforPayment(ticket: widget.ticket),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    AppLocalizations.of(context)!.ticketInformation,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                InforTicket(ticket: widget.ticket),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(35, 0, 35, 25),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedMethod.isEmpty
                      ? const Color(MyColor.grey)
                      : const Color(MyColor.pr8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (selectedMethod.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.pleaseSelectPaymentMethod,
                    ),
                  ),
                );
                return;
              }
              await _userTicketController.createUserTicket(widget.ticket);
              // print("🚀 Gọi hàm tạo link thanh toán...");
              // final url = await createVNPayPayment(widget.ticket.price);
              // if (!context.mounted) return;
              // if (url != null) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) => VNPayWebViewPage(
              //         paymentUrl: url,
              //         onPaymentComplete: (bool success) async {
              //           final message = success
              //               ? 'Thanh toán thành công!'
              //               : 'Thanh toán thất bại hoặc bị huỷ';
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(content: Text(message)),
              //           );
              //           if (success) {
              //             await _userTicketController.createUserTicket(widget.ticket);
              //             if (!mounted) return;
              //             final result = await showDialog<bool>(
              //               context: context,
              //               builder: (context) => AlertDialog(
              //                 backgroundColor: Color(MyColor.white), // Màu nền dialog
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(16),
              //                 ),
              //                 title: Row(
              //                   children: [
              //                     Icon(Icons.check_circle, color: Colors.green, size: 28),
              //                     const SizedBox(width: 8),
              //                     Text(
              //                       'Thanh toán thành công',
              //                       style: TextStyle(
              //                         color: Color(MyColor.pr9), // Màu chữ tiêu đề
              //                         fontWeight: FontWeight.bold,
              //                         fontSize: 18,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 content: const Text(
              //                   'Bạn có muốn chuyển đến trang vé của tôi không?',
              //                   style: TextStyle(
              //                     fontSize: 16,
              //                     color: Color(MyColor.pr8), // Màu chữ nội dung
              //                   ),
              //                 ),
              //                 actionsAlignment: MainAxisAlignment.end,
              //                 actions: [
              //                   TextButton(
              //                     style: TextButton.styleFrom(
              //                       foregroundColor: Color(MyColor.pr7), // Màu chữ nút Hủy
              //                     ),
              //                     onPressed: () => Navigator.of(context).pop(false),
              //                     child: const Text('Hủy'),
              //                   ),
              //                   ElevatedButton(
              //                     style: ElevatedButton.styleFrom(
              //                       backgroundColor: Color(MyColor.pr8), // Màu nền nút Đồng ý
              //                       foregroundColor: Color(MyColor.white), // Màu chữ nút Đồng ý
              //                       shape: RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.circular(8),
              //                       ),
              //                     ),
              //                     onPressed: () => Navigator.of(context).pop(true),
              //                     child: const Text('Đồng ý'),
              //                   ),
              //                 ],
              //               ),
              //             );
              //             if (!mounted) return; // Thêm dòng này trước khi dùng context.goNamed
              //             if (result == true) {
              //               context.goNamed(
              //                 RouterName.my_ticket,
              //                 queryParameters: {'tapIndex': '1'},
              //               );
              //             }
              //           }
              //         },
              //       ),
              //     ),
              //   );
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text("Không tạo được link thanh toán")),
              //   );
              // }
            },
            child: Text(
              '${AppLocalizations.of(context)!.pay} ${NumberFormat('#,###', 'vi_VN').format(widget.ticket.price)} đ',
              style: const TextStyle(
                fontSize: 16,
                color: Color(MyColor.pr1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget paymentMethod(Widget image, String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);
    final iconColor = isDarkMode ? Colors.white70 : const Color(MyColor.pr9);

    return GestureDetector(
      onTap: () {
        setState(() {
          showPaymentMethor = !showPaymentMethor;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 5, top: 5),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(width: 22, height: 18, child: image),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 8,
              child: Text(
                title,
                style: TextStyle(color: textColor, fontSize: 14),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child:
                    showPaymentMethor
                        ? Icon(
                          Icons.keyboard_arrow_down,
                          size: 23,
                          color: iconColor,
                        )
                        : Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: iconColor,
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showPayment(Widget image, String title, String status) {
    final String checkStatus = 'active';
    return GestureDetector(
      onTap: () {
        status == checkStatus
            ? setState(() {
              showPaymentMethor = !showPaymentMethor;
              selectedMethod = title;
              logoSelectedMethod = image;
            })
            : ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.paymentMethodNotSupported,
                ),
              ),
            );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(left: 15, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color:
              status == checkStatus ? Color(MyColor.white) : Colors.grey[300],
          border: Border(
            left: BorderSide(color: Color(MyColor.pr8), width: 3),
            bottom: BorderSide(color: Color(MyColor.pr8), width: 0.5),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(width: 22, height: 18, child: image),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 8,
              child: Text(
                title,
                style: TextStyle(color: Color(MyColor.pr9), fontSize: 14),
              ),
            ),
            status == checkStatus
                ? Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Checkbox(
                      value: selectedMethod == title,
                      onChanged: (_) {},
                      shape: const CircleBorder(),
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                    ),
                  ),
                )
                : Container(height: 45),
          ],
        ),
      ),
    );
  }

  Widget paymentMethodList() {
    if (isLoadingPayment) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, index) => const StationCardSkeleton(),
      );
    }
    if (paymentMethods.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noPaymentMethodsSupported,
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
        return showPayment(
          Image.network(method.logoUrl),
          method.name,
          method.status,
        );
      },
    );
  }
}
