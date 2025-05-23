import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';
import '../../themes/colors/colors.dart';
import '../forget_password/changepassword.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background color
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(MyColor.pr2), Color(MyColor.white)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/login.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(color: Colors.black.withValues(alpha: 0.1)),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Center(child: AppLogo()),
                  const Spacer(),
                  _buildVerificationCard(context),
                  const Spacer(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(MyColor.pr2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Nhập mã xác nhập',
            style: TextStyle(
              color: Color(MyColor.black),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Mã xác nhận đã được gửi đến email của bạn',
            style: TextStyle(
              color: Color(MyColor.black),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Code input field
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(MyColor.grey).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                hintText: 'Mã xác nhận',
                hintStyle: TextStyle(color: Color(MyColor.grey)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 20),
          
          // Confirm button
          PrimaryButton(
            text: 'Xác nhận',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
            ),
            color: const Color(MyColor.pr8),
          ),
          const SizedBox(height: 16),
          
          // Change email text
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              'Thay đổi Email',
              style: TextStyle(
                color: Color(MyColor.pr8),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}