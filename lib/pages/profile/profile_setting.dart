import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../themes/colors/colors.dart';
import '../../apps/router/router_name.dart';

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
        child: Column(
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
            _SettingItem(
              title: 'Đổi mật khẩu',
              onTap: () {},
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Color(MyColor.grey),
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
                    style: TextStyle(color: Color(MyColor.grey), fontSize: 15),
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
              onTap: () {},
              trailing: Switch(
                value: false,
                onChanged: null,
                activeColor: Color(MyColor.pr8),
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
                  onPressed: () {},
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
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
