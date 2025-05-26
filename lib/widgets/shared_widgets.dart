import 'package:flutter/material.dart';
import '../themes/colors/colors.dart';
import '../constants/app_constants.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;

  const AppBackButton({
    Key? key,
    this.onPressed,
    this.iconColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.backButton.copyWith(
        color: backgroundColor,
      ),
      child: IconButton(
        onPressed: onPressed ?? () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: iconColor ?? const Color(MyColor.black),
          size: AppDimensions.iconSize,
        ),
        padding: const EdgeInsets.all(AppSpacing.xs),
        constraints: const BoxConstraints(
          minWidth: AppDimensions.backButtonSize,
          minHeight: AppDimensions.backButtonSize,
        ),
      ),
    );
  }
}

/// Reusable auth header component
class AuthHeader extends StatelessWidget {
  final String title;
  final String? greeting;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final bool showLogo;

  const AuthHeader({
    Key? key,
    required this.title,
    this.greeting = 'Xin Chào!!',
    this.onBackPressed,
    this.showBackButton = true,
    this.showLogo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxxl),
        
        // Back button and greeting row
        if (showBackButton)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: [
                AppBackButton(onPressed: onBackPressed),
                const SizedBox(width: AppSpacing.md),
                if (greeting != null)
                  Text(greeting!, style: AppTextStyles.greeting),
              ],
            ),
          ),
        
        const SizedBox(height: AppSpacing.xxl),
        
        // Logo
        if (showLogo) const Center(child: AppLogo()),
        if (showLogo) const SizedBox(height: AppSpacing.xxxl),
        
        // Title
        Center(
          child: Text(title, style: AppTextStyles.title),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

/// Enhanced App Logo with customizable height
class AppLogo extends StatelessWidget {
  final double height;

  const AppLogo({Key? key, this.height = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppAssets.logo, height: height);
  }
}

/// Enhanced TextField with better validation integration
class AppTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isRoundedStyle;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool enabled;
  final int? maxLength;
  final TextAlign textAlign;
  final TextStyle? style;

  const AppTextField({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isRoundedStyle = true,
    this.suffix,
    this.validator,
    this.errorText,
    this.enabled = true,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: maxLength != null ? null : AppDimensions.inputHeight,
          decoration: isRoundedStyle
              ? AppDecorations.roundedInput(hasError: errorText != null)
              : BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  border: Border.all(
                    color: errorText != null ? Colors.red : const Color(MyColor.pr3),
                    width: 1,
                  ),
                ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: style ?? const TextStyle(fontSize: 16),
            validator: validator,
            enabled: enabled,
            maxLength: maxLength,
            textAlign: textAlign,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(MyColor.grey)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: 13,
              ),
              suffixIcon: suffix,
              counterText: maxLength != null ? '' : null,
              errorStyle: const TextStyle(height: 0, fontSize: 0),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.xxs,
              left: AppSpacing.sm,
            ),
            child: Text(errorText!, style: AppTextStyles.errorText),
          ),
      ],
    );
  }
}

/// Enhanced Password field with better validation
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isRoundedStyle;
  final String? Function(String?)? validator;
  final String? errorText;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.label,
    this.isRoundedStyle = true,
    this.validator,
    this.errorText,
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
      validator: widget.validator,
      errorText: widget.errorText,
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

/// Enhanced Primary Button
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double? width;
  final Color color;
  final bool isLoading;
  final EdgeInsets? padding;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onTap,
    this.width,
    this.color = const Color(MyColor.pr8),
    this.isLoading = false,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      padding: padding,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          height: AppDimensions.buttonHeight,
          decoration: BoxDecoration(
            color: isLoading ? color.withOpacity(0.6) : color,
            borderRadius: BorderRadius.circular(AppDimensions.roundBorderRadius),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: AppSpacing.lg,
                    height: AppSpacing.lg,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(text, style: AppTextStyles.buttonText),
          ),
        ),
      ),
    );
  }
}

/// Enhanced Google Button
class GoogleButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? width;
  final bool isLoading;

  const GoogleButton({
    Key? key,
    required this.onTap,
    this.width,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 140,
      height: AppDimensions.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(MyColor.pr3)),
        color: const Color(MyColor.white),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: isLoading ? null : onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                const SizedBox(
                  width: AppSpacing.lg,
                  height: AppSpacing.lg,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(MyColor.pr8)),
                  ),
                ),
              ] else ...[
                const Text(
                  'Google',
                  style: TextStyle(fontSize: 16, color: Color(MyColor.black)),
                ),
                const SizedBox(width: AppSpacing.xs),
                Image.asset(AppAssets.googleIcon, height: AppSpacing.lg, width: AppSpacing.lg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Enhanced SnackBar utility
class AppSnackBar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = AppDurations.medium,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: AppSpacing.lg,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Color(MyColor.white),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? const Color(MyColor.red) : Colors.green.shade600,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }
}

/// Auth Background with gradient and image
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                AppAssets.loginBackground,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.defaultPadding,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Divider with "or" text
class OrDivider extends StatelessWidget {
  final String text;

  const OrDivider({Key? key, this.text = AppMessages.orText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: AppDecorations.dividerLine,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(MyColor.grey),
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: AppDecorations.dividerLine,
          ),
        ),
      ],
    );
  }
}

/// Account link text (e.g., "Don't have account? Register")
class AccountLinkText extends StatelessWidget {
  final String question;
  final String linkText;
  final VoidCallback onTap;

  const AccountLinkText({
    Key? key,
    required this.question,
    required this.linkText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question, style: AppTextStyles.bodyText),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: const Color(MyColor.pr8),
            padding: const EdgeInsets.only(left: AppSpacing.xxs),
            minimumSize: const Size(10, 10),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(linkText, style: AppTextStyles.linkText),
        ),
      ],
    );
  }
}