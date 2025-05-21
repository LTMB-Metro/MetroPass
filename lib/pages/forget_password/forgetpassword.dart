import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/shared_widgets.dart';
import '../../themes/colors/colors.dart';
import '../../apps/router/router_name.dart';
import '../forget_password/verification.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 
                MediaQuery.of(context).padding.top - 
                MediaQuery.of(context).padding.bottom,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const BackButton(),
                const SizedBox(height: 30),
                const Center(child: AppLogo()),
                const SizedBox(height: 40),
                Center(child: Text('Quên mật khẩu', style: AppStyles.titleStyle)),
                const SizedBox(height: 30),
                
                // Email input
                AppTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                
                // Send code button
                PrimaryButton(
                  text: 'Gửi mã',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VerificationPage()),
                  ),
                  color: const Color(MyColor.pr8),
                ),
                
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => context.goNamed(RouterName.login),
                      child: Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Color(MyColor.pr8),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}