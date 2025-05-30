import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../themes/colors/colors.dart';
import '../../apps/router/router_name.dart';
import '../../controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/validators.dart';

class ProfileSettingPage extends StatelessWidget {
  const ProfileSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColor.pr2),
      appBar: AppBar(
        backgroundColor: const Color(MyColor.pr2),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(MyColor.pr9)),
          onPressed: () => context.goNamed(RouterName.profile),
        ),
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            color: Color(MyColor.pr9),
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(MyColor.pr8)),
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
                const Text(
                  'Tài khoản',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(MyColor.pr9),
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
                        title: 'Đổi mật khẩu',
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
                                    title: const Text(
                                      'Đổi mật khẩu',
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
                                            labelText: 'Mật khẩu hiện tại',
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
                                            labelText: 'Mật khẩu mới',
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
                                              child: const Text(
                                                'Quên mật khẩu?',
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
                                                      const SnackBar(
                                                        content: Text(
                                                          'Đổi mật khẩu thành công!',
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
                                                          'Mật khẩu hiện tại không đúng.';
                                                      setState(() {
                                                        currentPasswordError =
                                                            message;
                                                        isLoading = false;
                                                      });
                                                    } else {
                                                      errorMsg =
                                                          'Đổi mật khẩu thất bại: ${e is FirebaseAuthException ? e.message : e.toString()}';
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
                                                : const Text('Đổi mật khẩu'),
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
                  title: 'Ngôn ngữ',
                  onTap: () {},
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Tiếng việt',
                        style: TextStyle(
                          color: Color(MyColor.grey),
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Color(MyColor.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Giao diện',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(MyColor.pr9),
                  ),
                ),
                const SizedBox(height: 8),
                _SettingItem(
                  title: 'Chế độ tối',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tính năng đang được phát triển'),
                      ),
                    );
                  },
                  trailing: Container(
                    height: 32,
                    alignment: Alignment.center,
                    child: Switch(
                      value: false,
                      onChanged: (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tính năng đang được phát triển'),
                          ),
                        );
                      },
                      activeColor: Color(MyColor.pr8),
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(MyColor.white),
                        foregroundColor: const Color(MyColor.pr9),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                backgroundColor: const Color(MyColor.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text(
                                  'Xác nhận đăng xuất',
                                  style: TextStyle(
                                    color: Color(MyColor.pr9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text(
                                  'Bạn có chắc muốn đăng xuất không?',
                                  style: TextStyle(color: Color(MyColor.pr9)),
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
                      child: const Text(
                        'Đăng xuất',
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(MyColor.white),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(MyColor.pr9),
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
