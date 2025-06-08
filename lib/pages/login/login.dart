import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:metropass/apps/router/router_name.dart';
import 'package:metropass/constants/app_constants.dart';
import 'package:metropass/pages/base_auth_page.dart';
import 'package:metropass/widgets/shared_widgets.dart';
import '../../controllers/auth_controller.dart';
import '../../themes/colors/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/validators.dart';

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

  // Loading states
  bool isLoginLoading = false;
  bool isGoogleLoading = false;

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

    final passwordError = Validators.validatePasswordRequired(
      _passwordController.text,
    );
    if (passwordError != null) {
      setState(() => _passwordError = passwordError);
      isValid = false;
    }

    return isValid;
  }

  Future<void> _handleLogin() async {
    if (!_validateForSubmission()) {
      showMessage(AppLocalizations.of(context)!.fillAllFields, isError: true);
      return;
    }
    setState(() => isLoginLoading = true);
    final authController = context.read<AuthController>();
    await handleAsyncAction(
      () => authController.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        context: context,
      ),
      successMessage: AppLocalizations.of(context)!.loginSuccess,
      errorMessage:
          authController.errorMessage ??
          AppLocalizations.of(context)!.loginFailed,
    );
    if (mounted) setState(() => isLoginLoading = false);
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => isGoogleLoading = true);
    final authController = context.read<AuthController>();
    await handleAsyncAction(
      () => authController.signInWithGoogle(context: context),
      successMessage: AppLocalizations.of(context)!.googleSignInSuccess,
      errorMessage:
          authController.errorMessage ??
          AppLocalizations.of(context)!.googleSignInFailed,
    );
    if (mounted) setState(() => isGoogleLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return buildPageStructure(
          onBackPressed: () => context.goNamed(RouterName.welcome),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              AuthHeader(
                title: AppLocalizations.of(context)!.login,
                onBackPressed: () => context.goNamed(RouterName.welcome),
                isKeyboardOpen: isKeyboardOpen,
              ),

              // Form fields
              buildFormContainer(
                children: [
                  AppTextField(
                    hintText: AppLocalizations.of(context)!.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  PasswordField(
                    controller: _passwordController,
                    label: AppLocalizations.of(context)!.password,
                    errorText: _passwordError,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed:
                          () => context.goNamed(RouterName.forgotPassword),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(MyColor.pr8),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 20),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
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
                    question: AppLocalizations.of(context)!.noAccount,
                    linkText: AppLocalizations.of(context)!.register,
                    onTap: () => context.goNamed(RouterName.register),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Auth actions
                  buildAuthActions(
                    primaryButtonText: AppLocalizations.of(context)!.login,
                    onPrimaryTap: _handleLogin,
                    onGoogleTap: _handleGoogleSignIn,
                    isPrimaryLoading: isLoginLoading,
                    isGoogleLoading: isGoogleLoading,
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
