import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../base_auth_page.dart';
import '../../widgets/shared_widgets.dart';
import '../../constants/app_constants.dart';
import '../../utils/validators.dart';
import '../../apps/router/router_name.dart';
import '../../controllers/auth_controller.dart';
import '../../themes/colors/colors.dart';

class LoginPage extends BaseAuthPage {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _OptimizedLoginPageState();
}

class _OptimizedLoginPageState extends BaseAuthPageState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Error messages
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  void _validateEmail() {
    setState(() {
      _emailError = Validators.validateEmail(_emailController.text);
    });
  }

  void _validatePassword() {
    setState(() {
      _passwordError = Validators.validatePassword(_passwordController.text);
    });
  }

  bool _validateForSubmission() {
    bool isValid = true;

    final emailError = Validators.validateEmailRequired(_emailController.text);
    if (emailError != null) {
      setState(() => _emailError = emailError);
      isValid = false;
    }

    final passwordError = Validators.validatePasswordRequired(_passwordController.text);
    if (passwordError != null) {
      setState(() => _passwordError = passwordError);
      isValid = false;
    }

    return isValid;
  }

  Future<void> _handleLogin() async {
    if (!_validateForSubmission()) {
      showMessage(AppMessages.fillAllFields, isError: true);
      return;
    }

    final authController = context.read<AuthController>();

    await handleAsyncAction(
      () => authController.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
      successMessage: AppMessages.loginSuccess,
      errorMessage: authController.errorMessage ?? AppMessages.loginFailed,
      onSuccess: () => navigateWithDelay(
        () => context.goNamed(RouterName.home),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    final authController = context.read<AuthController>();

    await handleAsyncAction(
      () => authController.signInWithGoogle(),
      successMessage: AppMessages.googleSignInSuccess,
      errorMessage: authController.errorMessage ?? AppMessages.googleSignInFailed,
      onSuccess: () => navigateWithDelay(
        () => context.goNamed(RouterName.home),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return buildPageStructure(
          onBackPressed: () => context.goNamed(RouterName.welcome),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              AuthHeader(
                title: 'Đăng nhập',
                onBackPressed: () => context.goNamed(RouterName.welcome),
              ),

              // Form fields
              buildFormContainer(
                children: [
                  AppTextField(
                    hintText: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  PasswordField(
                    controller: _passwordController,
                    label: 'Mật khẩu',
                    errorText: _passwordError,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.goNamed(RouterName.forgotPassword),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(MyColor.pr8),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 20),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Account link
                  AccountLinkText(
                    question: AppMessages.noAccount,
                    linkText: 'Đăng ký',
                    onTap: () => context.goNamed(RouterName.register),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Auth actions
                  buildAuthActions(
                    primaryButtonText: 'Đăng nhập',
                    onPrimaryTap: _handleLogin,
                    onGoogleTap: _handleGoogleSignIn,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}