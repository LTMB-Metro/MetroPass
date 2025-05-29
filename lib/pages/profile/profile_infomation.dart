import 'package:flutter/material.dart';
import '../../themes/colors/colors.dart';
import 'package:go_router/go_router.dart';
import '../../apps/router/router_name.dart';

class ProfileInformationPage extends StatelessWidget {
  const ProfileInformationPage({Key? key}) : super(key: key);

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
          'Thông tin cá nhân',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Avatar
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(MyColor.white),
                        border: Border.all(color: Color(MyColor.pr7)),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Color(MyColor.pr8),
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Thay đổi ảnh',
                      style: TextStyle(
                        color: Color(MyColor.grey),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Form fields
              _ProfileInfoField(label: 'Họ và tên', value: 'Nguyễn Văn A'),
              _ProfileInfoField(label: 'Số điện thoại', value: '0900700605'),
              _ProfileInfoField(
                label: 'Email',
                value: 'huy0812200415@gmail.com',
              ),
              _ProfileInfoField(label: 'Ngày sinh', value: '08/12/2004'),
              _ProfileInfoField(label: 'CCCD/CMND', value: '000808918210'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoField extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileInfoField({required this.label, required this.value, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Color(MyColor.grey),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: const Color(MyColor.white),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Color(MyColor.pr9),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/images/editor.png',
                    width: 20,
                    height: 20,
                    color: Color(MyColor.pr8),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
