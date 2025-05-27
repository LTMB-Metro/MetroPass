import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../base_auth_page.dart';
import '../../widgets/shared_widgets.dart';
import '../../constants/app_constants.dart';
import '../../utils/validators.dart';
import '../../apps/router/router_name.dart';
import '../../controllers/password_reset_controller.dart';
import '../../themes/colors/colors.dart';

class VerificationPage extends BaseAuthPage {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _OptimizedVerificationPageState();
}

class _OptimizedVerificationPageState extends BaseAuthPageState<VerificationPage> {
  final _codeController = TextEditingController();
  String? _otpError;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_validateOTP);
  }

  void _validateOTP() {
    setState(() {
      _otpError = Validators.validateOTP(_codeController.text);
    });
  }

  bool _validateForSubmission() {
    final otpError = Validators.validateOTPRequired(_codeController.text);
    if (otpError != null) {
      setState(() => _otpError = otpError);
      return false;
    }
    return true;
  }

  Future<void> _verifyOTP() async {
    if (!_validateForSubmission()) {
      showMessage(AppMessages.enterValidOTP, isError: true);
      return;
    }

    final resetController = context.read<PasswordResetController>();

    await handleAsyncAction(
      () => resetController.verifyOTPAndSendResetEmail(_codeController.text.trim()),
      successMessage: AppMessages.verificationSuccess,
      errorMessage: resetController.errorMessage ?? AppMessages.invalidOTP,
      onSuccess: () {
        navigateWithDelay(
          () {
            resetController.resetFlow();
            context.goNamed(RouterName.login);
          },
          delay: AppDurations.extraLong,
        );
      },
    );
  }

  Future<void> _resendOTP() async {
    final resetController = context.read<PasswordResetController>();

    if (!resetController.canResendOTP) {
      showMessage(
        AppMessages.waitToResend.replaceAll('{countdown}', '${resetController.otpResendCooldown}'),
        isError: true,
      );
      return;
    }

    await handleAsyncAction(
      () => resetController.resendOTP(),
      successMessage: AppMessages.otpResent,
      errorMessage: resetController.errorMessage ?? AppMessages.otpResendFailed,
    );
  }

  Widget _buildOTPField(PasswordResetController resetController) {
    return AppTextField(
      hintText: '000000',
      controller: _codeController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textAlign: TextAlign.center,
      errorText: _otpError,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
      ),
    );
  }

  Widget _buildResendSection(PasswordResetController resetController) {
    return Column(
      children: [
        // Resend OTP
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppMessages.didntReceiveCode,
              style: AppTextStyles.subtitle,
            ),
            TextButton(
              onPressed: resetController.canResendOTP ? _resendOTP : null,
              style: TextButton.styleFrom(
                foregroundColor: const Color(MyColor.pr8),
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 20),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                resetController.canResendOTP
                    ? AppMessages.resendText
                    : AppMessages.resendWithCountdown.replaceAll(
                        '{countdown}',
                        '${resetController.otpResendCooldown}',
                      ),
                style: TextStyle(
                  color: resetController.canResendOTP
                      ? const Color(MyColor.pr8)
                      : const Color(MyColor.grey),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: resetController.canResendOTP
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),

        // Change email
        Center(
          child: TextButton(
            onPressed: () {
              resetController.goBackToEmail();
              context.goNamed(RouterName.forgotPassword);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(MyColor.pr8),
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 20),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              AppMessages.changeEmail,
              style: AppTextStyles.linkText.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordResetController>(
      builder: (context, resetController, child) {
        return buildPageStructure(
          onBackPressed: () => context.goNamed(RouterName.forgotPassword),
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
                    title: 'Nhập mã xác nhận',
                    onBackPressed: () => context.goNamed(RouterName.forgotPassword),
                    greeting: null,
                  ),

                  // Subtitle with email
                  Center(
                    child: Text(
                      AppMessages.verificationInfo.replaceAll('{email}', resetController.email),
                      style: AppTextStyles.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),

                  // Form
                  buildFormContainer(
                    children: [
                      _buildOTPField(resetController),
                      const SizedBox(height: AppSpacing.xxl),

                      // Confirm button
                      PrimaryButton(
                        text: 'Xác nhận',
                        onTap: resetController.isLoading ? null : _verifyOTP,
                        isLoading: resetController.isLoading,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Resend section
                      _buildResendSection(resetController),
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