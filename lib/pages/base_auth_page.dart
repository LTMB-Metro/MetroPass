import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';
import '../constants/app_constants.dart';

abstract class BaseAuthPage extends StatefulWidget {
  const BaseAuthPage({Key? key}) : super(key: key);
}

/// Base state class with common functionality
abstract class BaseAuthPageState<T extends BaseAuthPage> extends State<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  /// Show message using AppSnackBar
  void showMessage(String message, {bool isError = false}) {
    AppSnackBar.show(context, message, isError: isError);
  }

  /// Handle async actions with loading state and error handling
  Future<void> handleAsyncAction(
    Future<bool> Function() action, {
    required String successMessage,
    String? errorMessage,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      final success = await action();

      if (!mounted) return;

      if (success) {
        showMessage(successMessage, isError: false);
        onSuccess?.call();
      } else {
        showMessage(
          errorMessage ??
              AppMessages.genericError.replaceAll('{error}', 'Unknown'),
          isError: true,
        );
        onError?.call();
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          AppMessages.genericError.replaceAll('{error}', e.toString()),
          isError: true,
        );
        onError?.call();
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  /// Navigate with delay for better UX
  Future<void> navigateWithDelay(
    VoidCallback navigation, {
    Duration delay = AppDurations.medium,
  }) async {
    await Future.delayed(delay);
    if (mounted) {
      navigation();
    }
  }

  /// Validate form fields
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  /// Clear form fields
  void clearForm() {
    formKey.currentState?.reset();
  }

  /// Show loading indicator
  void setLoading(bool loading) {
    if (mounted) {
      setState(() => isLoading = loading);
    }
  }

  /// Create form container with consistent styling
  Widget buildFormContainer({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(children: children),
    );
  }

  /// Create auth action buttons section
  Widget buildAuthActions({
    required String primaryButtonText,
    required VoidCallback onPrimaryTap,
    VoidCallback? onGoogleTap,
    bool showGoogleButton = true,
    double buttonWidth = 140,
    bool isPrimaryLoading = false,
    bool isGoogleLoading = false,
  }) {
    return Column(
      children: [
        Center(
          child: PrimaryButton(
            text: primaryButtonText,
            width: buttonWidth,
            onTap: isPrimaryLoading ? null : onPrimaryTap,
            isLoading: isPrimaryLoading,
          ),
        ),
        if (showGoogleButton) ...[
          const SizedBox(height: AppSpacing.lg),
          const OrDivider(),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: GoogleButton(
              onTap: isGoogleLoading ? null : onGoogleTap,
              width: buttonWidth,
              isLoading: isGoogleLoading,
            ),
          ),
        ],
      ],
    );
  }

  /// Build page structure with PopScope
  Widget buildPageStructure({
    required Widget child,
    required VoidCallback onBackPressed,
  }) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        onBackPressed();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: AuthBackground(
          child: Form(
            key: formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: child,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
