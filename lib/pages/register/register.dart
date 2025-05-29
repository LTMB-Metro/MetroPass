import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../base_auth_page.dart';
import '../../widgets/shared_widgets.dart';
import '../../constants/app_constants.dart';
import '../../utils/validators.dart';
import '../../apps/router/router_name.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends BaseAuthPage {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _OptimizedRegisterPageState();
}

class _OptimizedRegisterPageState extends BaseAuthPageState<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Error messages
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Loading states
  bool isRegisterLoading = false;
  bool isGoogleLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  void _validateName() {
    setState(() {
      _nameError = Validators.validateName(_nameController.text);
    });
  }

  void _validateEmail() {
    setState(() {
      _emailError = Validators.validateEmail(_emailController.text);
    });
  }

  void _validatePassword() {
    setState(() {
      _passwordError = Validators.validateStrongPassword(
        _passwordController.text,
      );
    });

    // Re-validate confirm password if it has value
    if (_confirmPasswordController.text.isNotEmpty) {
      _validateConfirmPassword();
    }
  }

  void _validateConfirmPassword() {
    setState(() {
      _confirmPasswordError = Validators.validateConfirmPassword(
        _confirmPasswordController.text,
        _passwordController.text,
      );
    });
  }

  bool _validateForSubmission() {
    bool isValid = true;

    final nameError = Validators.validateNameRequired(_nameController.text);
    if (nameError != null) {
      setState(() => _nameError = nameError);
      isValid = false;
    }

    final emailError = Validators.validateEmailRequired(_emailController.text);
    if (emailError != null) {
      setState(() => _emailError = emailError);
      isValid = false;
    }

    final passwordError = Validators.validateStrongPasswordRequired(
      _passwordController.text,
    );
    if (passwordError != null) {
      setState(() => _passwordError = passwordError);
      isValid = false;
    }

    final confirmPasswordError = Validators.validateConfirmPasswordRequired(
      _confirmPasswordController.text,
      _passwordController.text,
    );
    if (confirmPasswordError != null) {
      setState(() => _confirmPasswordError = confirmPasswordError);
      isValid = false;
    }

    return isValid;
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });
  }

  Future<void> _handleRegister() async {
    if (!_validateForSubmission()) {
      showMessage(AppMessages.fillAllFields, isError: true);
      return;
    }
    setState(() => isRegisterLoading = true);
    final authController = context.read<AuthController>();
    await handleAsyncAction(
      () => authController.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _nameController.text.trim(),
      ),
      successMessage: AppMessages.registerSuccess,
      errorMessage: authController.errorMessage ?? AppMessages.registerFailed,
      onSuccess: () {
        _clearForm();
        navigateWithDelay(
          () => context.goNamed(RouterName.login),
          delay: AppDurations.extraLong,
        );
      },
    );
    if (mounted) setState(() => isRegisterLoading = false);
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => isGoogleLoading = true);
    final authController = context.read<AuthController>();
    await handleAsyncAction(
      () => authController.signInWithGoogle(),
      successMessage: AppMessages.googleSignInSuccess,
      errorMessage:
          authController.errorMessage ?? AppMessages.googleSignInFailed,
      onSuccess:
          () => navigateWithDelay(() => context.goNamed(RouterName.home)),
    );
    if (mounted) setState(() => isGoogleLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return buildPageStructure(
          onBackPressed: () => context.goNamed(RouterName.login),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              AuthHeader(
                title: 'Đăng ký',
                onBackPressed: () => context.goNamed(RouterName.login),
                isKeyboardOpen: isKeyboardOpen,
              ),

              // Form fields
              buildFormContainer(
                children: [
                  AppTextField(
                    hintText: 'Tên người dùng',
                    controller: _nameController,
                    errorText: _nameError,
                  ),
                  const SizedBox(height: AppSpacing.md),

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
                  const SizedBox(height: AppSpacing.md),

                  PasswordField(
                    controller: _confirmPasswordController,
                    label: 'Xác nhận mật khẩu',
                    errorText: _confirmPasswordError,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Account link
                  AccountLinkText(
                    question: AppMessages.haveAccount,
                    linkText: 'Đăng nhập',
                    onTap: () => context.goNamed(RouterName.login),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Auth actions
                  buildAuthActions(
                    primaryButtonText: 'Đăng ký',
                    onPrimaryTap: _handleRegister,
                    onGoogleTap: _handleGoogleSignIn,
                    isPrimaryLoading: isRegisterLoading,
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
