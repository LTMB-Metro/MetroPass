import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/colors/colors.dart';
import 'package:go_router/go_router.dart';
import '../../apps/router/router_name.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/validators.dart';

/// Profile information page for viewing and editing user details
class ProfileInformationPage extends StatefulWidget {
  const ProfileInformationPage({Key? key}) : super(key: key);

  @override
  State<ProfileInformationPage> createState() => _ProfileInformationPageState();
}

class _ProfileInformationPageState extends State<ProfileInformationPage> {
  // Controllers for text input fields
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController birthdayController;
  late TextEditingController cccdController;

  // Focus nodes for managing input field focus
  late FocusNode nameFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode birthdayFocusNode;
  late FocusNode cccdFocusNode;

  // State variables for UI control
  bool obscureCCCD = true;
  bool isLoading = false;
  bool isEditingName = false;
  bool isEditingPhone = false;
  bool isEditingBirthday = false;
  bool isEditingCCCD = false;

  // Error messages for validation
  String? nameError;
  String? phoneError;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data
    final user = Provider.of<AuthController>(context, listen: false).userModel;
    nameController = TextEditingController(text: user?.username ?? '');
    phoneController = TextEditingController(text: user?.phonenumber ?? '');
    birthdayController = TextEditingController(
      text: user?.toMap()['birthday'] ?? '',
    );
    cccdController = TextEditingController(text: user?.toMap()['cccd'] ?? '');

    // Initialize focus nodes
    nameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    birthdayFocusNode = FocusNode();
    cccdFocusNode = FocusNode();

    // Add focus listeners to handle editing state
    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus && isEditingName) {
        setState(() {
          isEditingName = false;
          nameError = Validators.validateName(nameController.text);
        });
      }
    });
    phoneFocusNode.addListener(() {
      if (!phoneFocusNode.hasFocus && isEditingPhone) {
        setState(() {
          isEditingPhone = false;
          phoneError = Validators.validatePhoneNumber(phoneController.text);
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

    // Add text change listeners for real-time validation
    phoneController.addListener(() {
      if (isEditingPhone) {
        setState(() {
          phoneError = Validators.validatePhoneNumber(phoneController.text);
        });
      }
    });

    nameController.addListener(() {
      if (isEditingName) {
        setState(() {
          nameError = Validators.validateName(nameController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes
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

  /// Show a snackbar message for features under development
  void _showUpdateFeature() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.featureUpdating)),
    );
  }

  /// Update user profile information
  Future<void> _updateProfile() async {
    // Validate all fields before updating
    final nameValidation = Validators.validateName(nameController.text);
    final phoneValidation = Validators.validatePhoneNumber(
      phoneController.text,
    );

    setState(() {
      nameError = nameValidation;
      phoneError = phoneValidation;
    });

    // Check if there are any validation errors
    if (nameValidation != null || phoneValidation != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng kiểm tra lại thông tin đã nhập'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
        content: Text(
          success
              ? AppLocalizations.of(context)!.updateSuccess
              : AppLocalizations.of(context)!.updateFail,
        ),
      ),
    );
  }

  Future<void> _selectBirthday() async {
    DateTime? initialDate;
    try {
      if (birthdayController.text.isNotEmpty) {
        final parts = birthdayController.text.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          initialDate = DateTime(year, month, day);
        }
      }
    } catch (_) {}
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: AppLocalizations.of(context)!.birthday,
      locale: Localizations.localeOf(context),
    );
    if (picked != null) {
      final formatted =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {
        birthdayController.text = formatted;
      });
    }
  }

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
          AppLocalizations.of(context)!.personalInfo,
          style: TextStyle(
            color: textColor,
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
            // Get avatar URL from Firebase or user model
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
                  // Profile avatar section
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
                          child: Text(
                            AppLocalizations.of(context)!.changeAvatar,
                            style: const TextStyle(
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
                  // Full name field
                  _EditableField(
                    label: AppLocalizations.of(context)!.fullName,
                    controller: nameController,
                    focusNode: nameFocusNode,
                    readOnly: !isEditingName,
                    showEditIcon: !isEditingName,
                    errorText: nameError,
                    onEdit: () {
                      setState(() {
                        isEditingName = true;
                        nameError = null; // Clear error when starting to edit
                        FocusScope.of(context).requestFocus(nameFocusNode);
                      });
                    },
                  ),
                  // Phone number field
                  _EditableField(
                    label: AppLocalizations.of(context)!.phoneNumber,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    focusNode: phoneFocusNode,
                    readOnly: !isEditingPhone,
                    showEditIcon: !isEditingPhone,
                    errorText: phoneError,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onEdit: () {
                      setState(() {
                        isEditingPhone = true;
                        phoneError = null; // Clear error when starting to edit
                        FocusScope.of(context).requestFocus(phoneFocusNode);
                      });
                    },
                  ),

                  // Email field (read-only)
                  _EditableField(
                    label: AppLocalizations.of(context)!.email,
                    controller: TextEditingController(text: email),
                    focusNode: null,
                    readOnly: true,
                    showEditIcon: false,
                  ),
                  // Birthday field
                  _EditableField(
                    label: AppLocalizations.of(context)!.birthday,
                    controller: birthdayController,
                    focusNode: birthdayFocusNode,
                    hintText: 'dd/mm/yy',
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    showEditIcon: true,
                    onEdit: _selectBirthday,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Color(MyColor.pr8),
                      ),
                      onPressed: _selectBirthday,
                    ),
                  ),
                  // CCCD/CMND
                  _EditableField(
                    label: AppLocalizations.of(context)!.idCard,
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
                        backgroundColor:
                            isDarkMode
                                ? Colors.transparent
                                : const Color(MyColor.pr8),
                        foregroundColor: isDarkMode ? textColor : Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color:
                                isDarkMode
                                    ? const Color(0xFF424242)
                                    : Colors.transparent,
                          ),
                        ),
                      ),
                      onPressed: isLoading ? null : _updateProfile,
                      child:
                          isLoading
                              ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: isDarkMode ? textColor : Colors.white,
                                ),
                              )
                              : Text(
                                AppLocalizations.of(context)!.update,
                                style: TextStyle(
                                  color: isDarkMode ? textColor : Colors.white,
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
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
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
    this.errorText,
    this.inputFormatters,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);
    final fieldColor = isDarkMode ? Colors.black : const Color(MyColor.white);
    final labelColor =
        isDarkMode ? Colors.grey[400] : const Color(MyColor.grey);
    final errorColor = Colors.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: labelColor,
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
                inputFormatters: inputFormatters,
                style: TextStyle(
                  color: readOnly ? labelColor : textColor,
                  fontSize: 16,
                  fontStyle:
                      (hintText != null && controller.text.isEmpty)
                          ? FontStyle.italic
                          : FontStyle.normal,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  errorText: errorText,
                  errorStyle: TextStyle(color: errorColor, fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          errorText != null
                              ? errorColor
                              : (isDarkMode
                                  ? Colors.grey[800]!
                                  : const Color(MyColor.pr8)),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          errorText != null
                              ? errorColor
                              : (isDarkMode
                                  ? Colors.grey[800]!
                                  : const Color(MyColor.pr8)),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          errorText != null
                              ? errorColor
                              : (isDarkMode
                                  ? Colors.grey[800]!
                                  : const Color(MyColor.pr8)),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: errorColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: errorColor, width: 2),
                  ),
                  filled: true,
                  fillColor: fieldColor,
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
                                  color: const Color(MyColor.pr8),
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
                                  color: const Color(MyColor.pr8),
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
