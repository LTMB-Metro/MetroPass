import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/shared_widgets.dart';
import '../../apps/router/router_name.dart';
import '../../themes/colors/colors.dart';
import '../forget_password/forgetpassword.dart';
import '../register/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Xin Chào!!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(MyColor.black),
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: AppLogo()),
          
          // Main content - centered
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: _buildLoginForm(context),
              ),
            ),
          ),
          
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Đăng nhập', style: AppStyles.titleStyle),
        const SizedBox(height: 30),
        
        // Email field
        AppTextField(
          hintText: 'Email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        
        // Password field
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PasswordField(
              controller: _passwordController,
              label: 'Mật khẩu',
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(10, 25),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: const Color(MyColor.grey),
              ),
              child: const Text(
                'Quên mật khẩu?',
                style: TextStyle(fontSize: 13, color: Color(MyColor.grey)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Register text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bạn chưa có tài khoản?',
              style: TextStyle(fontSize: 15, color: Color(MyColor.black)),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterPage()),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color(MyColor.pr8),
                padding: const EdgeInsets.only(left: 4),
                minimumSize: const Size(10, 10),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Đăng ký',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Login button
        PrimaryButton(
          text: 'Pass',
          width: 140,
          onTap: () => context.goNamed(RouterName.home),
        ),
        const SizedBox(height: 18),
        
        // Google button
        GoogleButton(onTap: () {}, width: 140),
      ],
    );
  }
}