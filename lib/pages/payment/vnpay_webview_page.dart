import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNPayWebViewPage extends StatefulWidget {
  final String paymentUrl;
  final Function(bool) onPaymentComplete;

  const VNPayWebViewPage({
    super.key,
    required this.paymentUrl,
    required this.onPaymentComplete,
  });

  @override
  State<VNPayWebViewPage> createState() => _VNPayWebViewPageState();
}

class _VNPayWebViewPageState extends State<VNPayWebViewPage> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;
            print("🔍 Điều hướng tới: $url");

            if (url.contains("vnp_ResponseCode")) {
              final uri = Uri.parse(url);
              final responseCode = uri.queryParameters['vnp_ResponseCode'];

              print("📥 Mã phản hồi thanh toán: $responseCode");

              final isSuccess = responseCode == '00';
              widget.onPaymentComplete(isSuccess);

              Navigator.pop(context);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (error) {
            print("❌ Lỗi tài nguyên: $error");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
