import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../themes/colors/colors.dart';
import '../../apps/router/router_name.dart';
import '../../controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/validators.dart';
import '../my_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../themes/theme_provider.dart';

class ProfileSettingPage extends StatelessWidget {
  const ProfileSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.pr2);
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => context.goNamed(RouterName.profile),
        ),
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDarkMode ? Colors.grey[500] : const Color(MyColor.pr8),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Consumer<AuthController>(
          builder: (context, authController, _) {
            final user = authController.firebaseUser;
            final isGoogle =
                user?.providerData.any((p) => p.providerId == 'google.com') ??
                false;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.profile,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Opacity(
                  opacity: isGoogle ? 0.5 : 1.0,
                  child: IgnorePointer(
                    ignoring: isGoogle,
                    child: Tooltip(
                      message:
                          isGoogle
                              ? 'Bạn đã đăng nhập bằng Google, không thể đổi mật khẩu tại đây.'
                              : '',
                      child: _SettingItem(
                        title: AppLocalizations.of(context)!.changePassword,
                        onTap: () async {
                          final currentPasswordController =
                              TextEditingController();
                          final newPasswordController = TextEditingController();
                          bool isLoading = false;
                          bool obscureCurrent = true;
                          bool obscureNew = true;
                          String? currentPasswordError;
                          String? newPasswordError;
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    backgroundColor: const Color(MyColor.white),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.changePassword,
                                      style: TextStyle(
                                        color: Color(MyColor.pr9),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: currentPasswordController,
                                          obscureText: obscureCurrent,
                                          decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(
                                                  context,
                                                )!.currentPassword,
                                            labelStyle: const TextStyle(
                                              color: Color(MyColor.pr8),
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                obscureCurrent
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Color(MyColor.pr8),
                                              ),
                                              onPressed: () {
                                                setState(
                                                  () =>
                                                      obscureCurrent =
                                                          !obscureCurrent,
                                                );
                                              },
                                            ),
                                            errorText: currentPasswordError,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: newPasswordController,
                                          obscureText: obscureNew,
                                          decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(
                                                  context,
                                                )!.newPassword,
                                            labelStyle: const TextStyle(
                                              color: Color(MyColor.pr8),
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                obscureNew
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Color(MyColor.pr8),
                                              ),
                                              onPressed: () {
                                                setState(
                                                  () =>
                                                      obscureNew = !obscureNew,
                                                );
                                              },
                                            ),
                                            errorText: newPasswordError,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                context.goNamed(
                                                  RouterName.forgotPassword,
                                                );
                                              },
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.forgotPassword,
                                                style: TextStyle(
                                                  color: Color(MyColor.pr8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            MyColor.pr8,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed:
                                            isLoading
                                                ? null
                                                : () async {
                                                  setState(() {
                                                    currentPasswordError = null;
                                                    newPasswordError = null;
                                                  });
                                                  final currentPassword =
                                                      currentPasswordController
                                                          .text
                                                          .trim();
                                                  final newPassword =
                                                      newPasswordController.text
                                                          .trim();
                                                  final newPassError =
                                                      Validators.validatePassword(
                                                        newPassword,
                                                      );
                                                  if (newPassError != null) {
                                                    setState(() {
                                                      newPasswordError =
                                                          newPassError;
                                                    });
                                                    return;
                                                  }
                                                  setState(
                                                    () => isLoading = true,
                                                  );
                                                  final authController =
                                                      Provider.of<
                                                        AuthController
                                                      >(context, listen: false);
                                                  final user =
                                                      authController
                                                          .firebaseUser;
                                                  String? errorMsg;
                                                  try {
                                                    if (user == null ||
                                                        user.email == null)
                                                      throw 'Chưa đăng nhập';
                                                    final cred =
                                                        EmailAuthProvider.credential(
                                                          email: user.email!,
                                                          password:
                                                              currentPassword,
                                                        );
                                                    await user
                                                        .reauthenticateWithCredential(
                                                          cred,
                                                        );
                                                    await user.updatePassword(
                                                      newPassword,
                                                    );
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.changePasswordSuccess,
                                                        ),
                                                      ),
                                                    );
                                                  } catch (e) {
                                                    String? message;
                                                    if (e
                                                            is FirebaseAuthException &&
                                                        (e.code ==
                                                                'wrong-password' ||
                                                            e.code ==
                                                                'invalid-credential')) {
                                                      message =
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.currentPasswordIncorrect;
                                                      setState(() {
                                                        currentPasswordError =
                                                            message;
                                                        isLoading = false;
                                                      });
                                                    } else {
                                                      errorMsg =
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.changePasswordFail +
                                                          ': ${e is FirebaseAuthException ? e.message : e.toString()}';
                                                      setState(
                                                        () => isLoading = false,
                                                      );
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            errorMsg,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                        child:
                                            isLoading
                                                ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                )
                                                : Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.changePassword,
                                                ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: Color(MyColor.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                _SettingItem(
                  title: AppLocalizations.of(context)!.language,
                  onTap: () async {
                    final localeProvider = Provider.of<LocaleProvider>(
                      context,
                      listen: false,
                    );
                    final currentLocale = localeProvider.locale.languageCode;
                    final selected = await showDialog<String>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor: backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Text(
                              AppLocalizations.of(context)!.language,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _LanguageOption(
                                  title:
                                      AppLocalizations.of(context)!.vietnamese,
                                  subtitle: 'Tiếng Việt',
                                  flag: '🇻🇳',
                                  isSelected: currentLocale == 'vi',
                                  onTap: () => Navigator.pop(context, 'vi'),
                                  textColor: textColor,
                                ),
                                const SizedBox(height: 12),
                                _LanguageOption(
                                  title: AppLocalizations.of(context)!.english,
                                  subtitle: 'English',
                                  flag: '🇺🇸',
                                  isSelected: currentLocale == 'en',
                                  onTap: () => Navigator.pop(context, 'en'),
                                  textColor: textColor,
                                ),
                              ],
                            ),
                          ),
                    );
                    if (selected != null && selected != currentLocale) {
                      await localeProvider.setLocale(Locale(selected));
                    }
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer<LocaleProvider>(
                        builder: (context, localeProvider, _) {
                          final currentLocale =
                              localeProvider.locale.languageCode;
                          return Row(
                            children: [
                              Text(
                                currentLocale == 'vi' ? '🇻🇳' : '🇺🇸',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                currentLocale == 'en'
                                    ? AppLocalizations.of(context)!.english
                                    : AppLocalizations.of(context)!.vietnamese,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: textColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  AppLocalizations.of(context)!.interface,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                _SettingItem(
                  title: AppLocalizations.of(context)!.darkMode,
                  onTap: () {
                    final themeProvider = Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    );
                    themeProvider.toggleTheme();
                  },
                  trailing: Container(
                    height: 32,
                    alignment: Alignment.center,
                    child: Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) {
                        return Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (_) {
                            themeProvider.toggleTheme();
                          },
                          activeColor: Color(MyColor.pr8),
                        );
                      },
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode
                                ? Colors.transparent
                                : const Color(MyColor.pr8),
                        foregroundColor: isDarkMode ? textColor : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color:
                                isDarkMode
                                    ? Colors.grey[500]!
                                    : Colors.transparent,
                            width: isDarkMode ? 1.5 : 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                backgroundColor: backgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.logoutConfirm,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.logoutConfirmContent,
                                  style: TextStyle(color: textColor),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color(
                                            MyColor.pr8,
                                          ),
                                        ),
                                        onPressed:
                                            () => Navigator.of(
                                              context,
                                            ).pop(false),
                                        child: const Text('Hủy'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            MyColor.pr8,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed:
                                            () =>
                                                Navigator.of(context).pop(true),
                                        child: const Text('Đăng xuất'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        );
                        if (shouldLogout == true) {
                          final authController = Provider.of<AuthController>(
                            context,
                            listen: false,
                          );
                          await authController.signOut();
                          context.goNamed(RouterName.login);
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.logout,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  const _SettingItem({
    required this.title,
    required this.onTap,
    this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.white);
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  isDarkMode
                      ? Border.all(color: Colors.grey[600]!, width: 1)
                      : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;
  final Color textColor;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.isSelected,
    required this.onTap,
    required this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: textColor, fontSize: 14),
      ),
      leading: Text(flag, style: const TextStyle(fontSize: 20)),
      trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
      onTap: onTap,
    );
  }
}
