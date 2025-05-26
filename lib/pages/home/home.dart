import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../themes/colors/colors.dart';
import '../../apps/router/router_name.dart';
import '../../widgets/shared_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthState();
    });
  }

  void _checkAuthState() {
    final authController = context.read<AuthController>();
    if (!authController.isAuthenticated) {
      context.goNamed(RouterName.login);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    AppSnackBar.show(context, message, isError: isError);
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                final authController = context.read<AuthController>();
                final success = await authController.signOut();
                
                if (mounted) {
                  if (success) {
                    _showMessage('Đăng xuất thành công', isError: false);
                    context.goNamed(RouterName.login);
                  } else {
                    _showMessage('Có lỗi khi đăng xuất', isError: true);
                  }
                }
              },
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trang chủ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(MyColor.pr8),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          if (authController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!authController.isAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.goNamed(RouterName.login);
            });
            return const SizedBox.shrink();
          }

          final currentUser = authController.userModel;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(MyColor.pr2), Color(MyColor.white)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: currentUser?.photoURL != null && 
                                        currentUser!.photoURL.isNotEmpty
                                    ? NetworkImage(currentUser.photoURL)
                                    : null,
                                backgroundColor: const Color(MyColor.pr3),
                                child: currentUser?.photoURL == null || 
                                        currentUser!.photoURL.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 30,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Xin chào!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(MyColor.grey),
                                      ),
                                    ),
                                    Text(
                                      currentUser?.username ?? 'User',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(MyColor.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Divider(),
                          const SizedBox(height: 10),
                          _buildUserInfo(currentUser),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Menu options
                    const Text(
                      'Tính năng',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(MyColor.black),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        children: [
                          _buildMenuCard(
                            icon: Icons.train,
                            title: 'Tàu điện',
                            subtitle: 'Thông tin tuyến',
                            color: Colors.blue,
                            onTap: () => _showMessage('Tính năng đang phát triển'),
                          ),
                          _buildMenuCard(
                            icon: Icons.credit_card,
                            title: 'Thẻ của tôi',
                            subtitle: 'Quản lý thẻ',
                            color: Colors.green,
                            onTap: () => _showMessage('Tính năng đang phát triển'),
                          ),
                          _buildMenuCard(
                            icon: Icons.history,
                            title: 'Lịch sử',
                            subtitle: 'Giao dịch',
                            color: Colors.orange,
                            onTap: () => _showMessage('Tính năng đang phát triển'),
                          ),
                          _buildMenuCard(
                            icon: Icons.settings,
                            title: 'Cài đặt',
                            subtitle: 'Tùy chỉnh',
                            color: Colors.purple,
                            onTap: () => _showMessage('Tính năng đang phát triển'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfo(currentUser) {
    return Column(
      children: [
        _buildInfoRow('Email', currentUser?.email ?? ''),
        const SizedBox(height: 8),
        _buildInfoRow('Số điện thoại', 
            currentUser?.phonenumber?.isEmpty != false 
                ? 'Chưa cập nhật' 
                : currentUser!.phonenumber),
        const SizedBox(height: 8),
        _buildInfoRow('Vai trò', currentUser?.role ?? 'user'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontSize: 14,
              color: Color(MyColor.grey),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(MyColor.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(MyColor.black),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(MyColor.grey),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}