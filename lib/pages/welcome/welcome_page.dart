import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metropass/apps/router/router_name.dart';
import '../../themes/colors/colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Ngăn không cho back thoát app
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        
        // Hiển thị dialog xác nhận thoát ứng dụng
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Thoát ứng dụng'),
              content: const Text('Bạn có chắc chắn muốn thoát ứng dụng không?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Thoát ứng dụng
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Thoát',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        // Set background
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(MyColor.pr2),
                Color(MyColor.white),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          // Logo
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 30,
                  ),
                  const Spacer(),
                  // Welcome image
                  Container(
                    width: 280,
                    height: 280,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(MyColor.pr7),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/welcome.png',
                        width: 260,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Text
                  Text(
                    'Ga gần - Vé sẵn',
                    style: TextStyle(
                      color: Color(MyColor.pr8),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Không chờ đợi - Không lo âu',
                    style: TextStyle(color: Color(MyColor.pr8), fontSize: 16),
                  ),
                  const Spacer(),
                  // Button start
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _buildStartButton(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Start button widget
  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.goNamed(RouterName.login),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(MyColor.pr8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Bắt đầu',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}