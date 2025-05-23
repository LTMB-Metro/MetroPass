import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/shared_widgets.dart';
import '../../themes/colors/colors.dart';
import '../../apps/router/router_name.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Xin Chào!!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(MyColor.black),
                ),
              ),
              const SizedBox(height: 30),
              const Center(child: AppLogo()),
              const SizedBox(height: 40),
              Center(child: Text('Đăng ký', style: AppStyles.titleStyle)),
              const SizedBox(height: 20),

              // Form fields
              AppTextField(hintText: 'Tên người dùng', controller: _nameController),
              const SizedBox(height: 12),
              AppTextField(
                hintText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              PasswordField(controller: _passwordController, label: 'Mật khẩu'),
              const SizedBox(height: 12),
              PasswordField(
                controller: _confirmPasswordController,
                label: 'Xác nhận mật khẩu',
              ),
              const SizedBox(height: 12),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn đã có tài khoản?',
                    style: TextStyle(fontSize: 14, color: Color(MyColor.black)),
                  ),
                  TextButton(
                    onPressed: () => context.goNamed(RouterName.login),
                    style: TextButton.styleFrom(
                      foregroundColor: Color(MyColor.pr8),
                      padding: const EdgeInsets.only(left: 4),
                      minimumSize: const Size(10, 10),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Register button
              Center(child: PrimaryButton(
                text: 'Đăng ký',
                width: 140,
                onTap: () => context.goNamed(RouterName.login),
              )),
              const SizedBox(height: 18),
              
              // Google button
              Center(child: GoogleButton(onTap: () {}, width: 140)),
            ],
          ),
        ),
      ),
    );
  }
}