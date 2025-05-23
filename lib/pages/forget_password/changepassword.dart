import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/shared_widgets.dart';
import '../../themes/colors/colors.dart';
import '../../apps/router/router_name.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validatePasswords() {
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      setState(() => _errorText = 'Vui lòng nhập đầy đủ thông tin');
      return false;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorText = 'Mật khẩu không khớp');
      return false;
    }
    
    if (_passwordController.text.length < 6) {
      setState(() => _errorText = 'Mật khẩu phải có ít nhất 6 ký tự');
      return false;
    }
    
    setState(() => _errorText = null);
    return true;
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
                Center(child: Text('Đổi mật khẩu mới', style: AppStyles.titleStyle)),
                const SizedBox(height: 40),
                
                // Password fields
                PasswordField(
                  controller: _passwordController,
                  label: 'Mật khẩu mới',
                  isRoundedStyle: false,
                ),
                const SizedBox(height: 25),
                PasswordField(
                  controller: _confirmPasswordController,
                  label: 'Xác nhận mật khẩu',
                  isRoundedStyle: false,
                ),
                
                // Error text
                if (_errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _errorText!,
                      style: const TextStyle(
                        color: Color(MyColor.red),
                        fontSize: 14,
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                
                // Confirm button
                PrimaryButton(
                  text: 'Xác nhận',
                  onTap: () {
                    if (_validatePasswords()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đổi mật khẩu thành công!'),
                          backgroundColor: Color(MyColor.pr8),
                        ),
                      );
                      
                      Future.delayed(
                        const Duration(seconds: 2), 
                        () => context.goNamed(RouterName.login)
                      );
                    }
                  },
                ),
                const Spacer(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}