import 'package:flutter/material.dart';
import '../../themes/colors/colors.dart';
import '../../constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import '../../apps/router/router_name.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(MyColor.pr1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: const Color(MyColor.pr1),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(MyColor.pr9)),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.goNamed(RouterName.home);
              }
            },
          ),
          title: const Text(
            'Tài khoản',
            style: TextStyle(
              color: Color(MyColor.pr9),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Image.asset('assets/images/logo.png', height: 24),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: const Color(MyColor.pr8)),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),
            // Avatar, Name, ID
            Center(
              child: Consumer<AuthController>(
                builder: (context, authController, _) {
                  final userModel = authController.userModel;
                  final firebaseUser = authController.firebaseUser;
                  final isLoggedIn =
                      authController.isAuthenticated && userModel != null;
                  String? avatarUrl;
                  if (isLoggedIn) {
                    // Nếu đăng nhập bằng Google, ưu tiên lấy avatar Google
                    avatarUrl =
                        firebaseUser?.photoURL?.isNotEmpty == true
                            ? firebaseUser!.photoURL
                            : (userModel.photoURL.isNotEmpty
                                ? userModel.photoURL
                                : null);
                  }
                  if (!isLoggedIn && authController.isLoading) {
                    // Hiệu ứng skeleton khi đang loading
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(MyColor.white),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  height: 18,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 60,
                                  height: 14,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (!isLoggedIn) {
                    // Nếu chưa đăng nhập, hiển thị mặc định
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(MyColor.white),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: const Color(MyColor.grey),
                            child: Icon(
                              Icons.person,
                              size: 48,
                              color: Color(MyColor.white),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Phan Văn A',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(MyColor.pr9),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'ID: MT-2004',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(MyColor.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  // Nếu đã đăng nhập, hiển thị dữ liệu thực tế
                  return GestureDetector(
                    onTap: () => context.goNamed(RouterName.profileInformation),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(MyColor.white),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: const Color(MyColor.grey),
                            backgroundImage:
                                (avatarUrl != null && avatarUrl.isNotEmpty)
                                    ? NetworkImage(avatarUrl)
                                    : null,
                            child:
                                (avatarUrl == null || avatarUrl.isEmpty)
                                    ? Icon(
                                      Icons.person,
                                      size: 48,
                                      color: Color(MyColor.white),
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 18),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userModel!.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(MyColor.pr9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Role: ${userModel.role.toUpperCase()}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(MyColor.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 48),
            // Menu buttons
            _ProfileMenuItem(
              icon: Icons.person,
              text: 'Thông tin cá nhân',
              onTap: () => context.goNamed(RouterName.profileInformation),
            ),
            _ProfileMenuItem(
              icon: Icons.confirmation_num,
              text: 'Vé của tôi',
              onTap: () => context.pushNamed(RouterName.profileTicket),
            ),
            _ProfileMenuItem(
              icon: Icons.history,
              text: 'Lịch sử giao dịch',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.settings,
              text: 'Cài đặt',
              onTap: () => context.pushNamed(RouterName.profileSetting),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Material(
        color: const Color(MyColor.white),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(MyColor.pr7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(MyColor.pr8), size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(MyColor.pr9),
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Color(MyColor.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
