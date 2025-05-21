import 'package:flutter/material.dart';
import '../themes/colors/colors.dart';

// Common constants
class AppConstants {
  static const double defaultPadding = 25.0;
  static const double buttonHeight = 50.0;
  static const double inputHeight = 45.0;
  static const double borderRadius = 10.0;
  static const double roundBorderRadius = 22.0;
}

// Common styles
class AppStyles {
  static TextStyle titleStyle = TextStyle(
    color: Color(MyColor.pr8),
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static TextStyle buttonTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  
  static InputDecoration textFieldDecoration(String hintText) => InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Color(MyColor.grey)),
    border: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
  );
  
  static BoxDecoration roundedInputDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppConstants.roundBorderRadius),
    border: Border.all(color: const Color(MyColor.pr3), width: 1),
  );
}

// Background widget
class AuthBackground extends StatelessWidget {
  final Widget child;
  
  const AuthBackground({Key? key, required this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(MyColor.pr2), Color(MyColor.white)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Background image
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
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// Back button
class AppBackButton extends StatelessWidget {
  const AppBackButton({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.arrow_back_ios,
          color: Color(MyColor.black),
          size: 22,
        ),
      ),
    );
  }
}

// App logo
class AppLogo extends StatelessWidget {
  final double height;
  
  const AppLogo({Key? key, this.height = 50}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/logo.png', height: height);
  }
}

// Text field
class AppTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isRoundedStyle;
  final Widget? suffix;
  
  const AppTextField({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isRoundedStyle = true,
    this.suffix,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.inputHeight,
      decoration: isRoundedStyle 
          ? AppStyles.roundedInputDecoration
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(color: const Color(MyColor.pr3), width: 1),
            ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: AppStyles.textFieldDecoration(hintText).copyWith(
          suffixIcon: suffix,
        ),
      ),
    );
  }
}

// Primary button
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final Color color;
  
  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.width = double.infinity,
    this.color = const Color(MyColor.pr8),
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: AppConstants.buttonHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppConstants.roundBorderRadius),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha:0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(text, style: AppStyles.buttonTextStyle),
        ),
      ),
    );
  }
}

// Google button
class GoogleButton extends StatelessWidget {
  final VoidCallback onTap;
  final double width;
  
  const GoogleButton({
    Key? key,
    required this.onTap,
    this.width = 140,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, 
      child: Container(
        width: double.infinity,
        height: AppConstants.buttonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(MyColor.pr3)),
          color: const Color(MyColor.white),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Google',
                  style: TextStyle(fontSize: 16, color: Color(MyColor.black)),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/email.png',
                  height: 20,
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Password field with toggle visibility
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isRoundedStyle;
  
  const PasswordField({
    Key? key,
    required this.controller,
    required this.label,
    this.isRoundedStyle = true,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hintText: widget.label,
      isPassword: !_isVisible,
      controller: widget.controller,
      isRoundedStyle: widget.isRoundedStyle,
      suffix: IconButton(
        icon: Icon(
          _isVisible ? Icons.visibility_off : Icons.visibility,
          color: const Color(MyColor.grey),
        ),
        onPressed: () {
          setState(() {
            _isVisible = !_isVisible;
          });
        },
      ),
    );
  }
}