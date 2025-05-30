import 'package:flutter/material.dart';
import '../../themes/colors/colors.dart';
import 'package:go_router/go_router.dart';
import '../../apps/router/router_name.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

class ProfileInformationPage extends StatefulWidget {
  const ProfileInformationPage({Key? key}) : super(key: key);

  @override
  State<ProfileInformationPage> createState() => _ProfileInformationPageState();
}

class _ProfileInformationPageState extends State<ProfileInformationPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController birthdayController;
  late TextEditingController cccdController;
  late FocusNode nameFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode birthdayFocusNode;
  late FocusNode cccdFocusNode;
  bool obscureCCCD = true;
  bool isLoading = false;
  bool isEditingName = false;
  bool isEditingPhone = false;
  bool isEditingBirthday = false;
  bool isEditingCCCD = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthController>(context, listen: false).userModel;
    nameController = TextEditingController(text: user?.username ?? '');
    phoneController = TextEditingController(text: user?.phonenumber ?? '');
    birthdayController = TextEditingController(
      text: user?.toMap()['birthday'] ?? '',
    );
    cccdController = TextEditingController(text: user?.toMap()['cccd'] ?? '');
    nameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    birthdayFocusNode = FocusNode();
    cccdFocusNode = FocusNode();
    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus && isEditingName) {
        setState(() {
          isEditingName = false;
        });
      }
    });
    phoneFocusNode.addListener(() {
      if (!phoneFocusNode.hasFocus && isEditingPhone) {
        setState(() {
          isEditingPhone = false;
        });
      }
    });
    birthdayFocusNode.addListener(() {
      if (!birthdayFocusNode.hasFocus && isEditingBirthday) {
        setState(() {
          isEditingBirthday = false;
        });
      }
    });
    cccdFocusNode.addListener(() {
      if (!cccdFocusNode.hasFocus && isEditingCCCD) {
        setState(() {
          isEditingCCCD = false;
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    cccdController.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    birthdayFocusNode.dispose();
    cccdFocusNode.dispose();
    super.dispose();
  }

  void _showUpdateFeature() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang được cập nhật')),
    );
  }

  Future<void> _updateProfile() async {
    setState(() => isLoading = true);
    final authController = Provider.of<AuthController>(context, listen: false);
    final success = await authController.updateProfile(
      username: nameController.text.trim(),
      phonenumber: phoneController.text.trim(),
      birthday: birthdayController.text.trim(),
      cccd: cccdController.text.trim(),
    );
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Cập nhật thành công!' : 'Cập nhật thất bại!'),
      ),
    );
  }

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
      body: Consumer<AuthController>(
        builder: (context, authController, _) {
          final user = authController.userModel;
          final firebaseUser = authController.firebaseUser;
          String? avatarUrl;
          if (user != null) {
            avatarUrl =
                firebaseUser?.photoURL?.isNotEmpty == true
                    ? firebaseUser!.photoURL
                    : (user.photoURL.isNotEmpty ? user.photoURL : null);
          }
          final email = user?.email ?? '';
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Avatar
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _showUpdateFeature,
                          child: CircleAvatar(
                            radius: 45,
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
                                      color: const Color(MyColor.white),
                                    )
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _showUpdateFeature,
                          child: const Text(
                            'Thay đổi ảnh',
                            style: TextStyle(
                              color: Color(MyColor.grey),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Họ và tên
                  _EditableField(
                    label: 'Họ và tên',
                    controller: nameController,
                    focusNode: nameFocusNode,
                    readOnly: !isEditingName,
                    showEditIcon: !isEditingName,
                    onEdit: () {
                      setState(() {
                        isEditingName = true;
                        FocusScope.of(context).requestFocus(nameFocusNode);
                      });
                    },
                  ),
                  // Số điện thoại
                  _EditableField(
                    label: 'Số điện thoại',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    focusNode: phoneFocusNode,
                    readOnly: !isEditingPhone,
                    showEditIcon: !isEditingPhone,
                    onEdit: () {
                      setState(() {
                        isEditingPhone = true;
                        FocusScope.of(context).requestFocus(phoneFocusNode);
                      });
                    },
                  ),
                  // Email (read only)
                  _EditableField(
                    label: 'Email',
                    controller: TextEditingController(text: email),
                    focusNode: null,
                    readOnly: true,
                    showEditIcon: false,
                  ),
                  // Ngày sinh
                  _EditableField(
                    label: 'Ngày sinh',
                    controller: birthdayController,
                    focusNode: birthdayFocusNode,
                    hintText: 'dd/mm/yyyy',
                    readOnly: !isEditingBirthday,
                    showEditIcon: !isEditingBirthday,
                    onEdit: () {
                      setState(() {
                        isEditingBirthday = true;
                        FocusScope.of(context).requestFocus(birthdayFocusNode);
                      });
                    },
                  ),
                  // CCCD/CMND
                  _EditableField(
                    label: 'CCCD/CMND',
                    controller: cccdController,
                    focusNode: cccdFocusNode,
                    obscureText: obscureCCCD,
                    readOnly: !isEditingCCCD,
                    showEditIcon: !isEditingCCCD,
                    onEdit: () {
                      setState(() {
                        isEditingCCCD = true;
                        FocusScope.of(context).requestFocus(cccdFocusNode);
                      });
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureCCCD ? Icons.visibility_off : Icons.visibility,
                        color: Color(MyColor.pr8),
                      ),
                      onPressed: () {
                        setState(() {
                          obscureCCCD = !obscureCCCD;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(MyColor.pr8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isLoading ? null : _updateProfile,
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text(
                                'Cập nhật',
                                style: TextStyle(
                                  color: Color(MyColor.white),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool obscureText;
  final String? hintText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool showEditIcon;
  final VoidCallback? onEdit;
  const _EditableField({
    required this.label,
    required this.controller,
    this.focusNode,
    this.readOnly = false,
    this.obscureText = false,
    this.hintText,
    this.keyboardType,
    this.suffixIcon,
    this.showEditIcon = false,
    this.onEdit,
    Key? key,
  }) : super(key: key);

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
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextField(
                controller: controller,
                focusNode: focusNode,
                readOnly: readOnly,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style: TextStyle(
                  color: readOnly ? Color(MyColor.grey) : Color(MyColor.pr9),
                  fontSize: 16,
                  fontStyle:
                      (hintText != null && controller.text.isEmpty)
                          ? FontStyle.italic
                          : FontStyle.normal,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(MyColor.white),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  suffixIcon:
                      (suffixIcon != null && showEditIcon)
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              suffixIcon!,
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/editor.png',
                                  width: 20,
                                  height: 20,
                                  color: Color(MyColor.pr8),
                                ),
                                onPressed: onEdit,
                              ),
                            ],
                          )
                          : (suffixIcon != null)
                          ? suffixIcon
                          : (showEditIcon
                              ? IconButton(
                                icon: Image.asset(
                                  'assets/images/editor.png',
                                  width: 20,
                                  height: 20,
                                  color: Color(MyColor.pr8),
                                ),
                                onPressed: onEdit,
                              )
                              : null),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
