import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../base_auth_page.dart';
import '../../widgets/shared_widgets.dart';
import '../../constants/app_constants.dart';
import '../../utils/validators.dart';
import '../../apps/router/router_name.dart';
import '../../controllers/password_reset_controller.dart';

class ForgotPasswordPage extends BaseAuthPage {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _OptimizedForgotPasswordPageState();
}

class _OptimizedForgotPasswordPageState extends BaseAuthPageState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    setState(() {
      _emailError = Validators.validateEmail(_emailController.text);
    });
  }

  bool _validateForSubmission() {
    final emailError = Validators.validateEmailRequired(_emailController.text);
    if (emailError != null) {
      setState(() => _emailError = emailError);
      return false;
    }
    return true;
  }

  Future<void> _sendOTPCode() async {
    if (!_validateForSubmission()) {
      showMessage(AppMessages.enterValidEmail, isError: true);
      return;
    }

    final resetController = context.read<PasswordResetController>();

    await handleAsyncAction(
      () => resetController.sendOTP(_emailController.text.trim()),
      successMessage: AppMessages.otpSent,
      errorMessage: resetController.errorMessage ?? AppMessages.otpSendFailed,
      onSuccess: () => navigateWithDelay(
        () => context.goNamed(RouterName.verification),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordResetController>(
      builder: (context, resetController, child) {
        return buildPageStructure(
          onBackPressed: () => context.goNamed(RouterName.login),
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
                  // Header
                  AuthHeader(
                    title: 'Quên mật khẩu',
                    onBackPressed: () => context.goNamed(RouterName.login),
                    greeting: null, // No greeting for this page
                  ),

                  // Subtitle
                  Center(
                    child: Text(
                      AppMessages.forgotPasswordInfo,
                      style: AppTextStyles.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Form
                  buildFormContainer(
                    children: [
                      AppTextField(
                        hintText: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        errorText: _emailError,
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      PrimaryButton(
                        text: 'Gửi mã',
                        onTap: resetController.isLoading ? null : _sendOTPCode,
                        isLoading: resetController.isLoading,
                      ),
                    ],
                  ),

                  const Spacer(),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}