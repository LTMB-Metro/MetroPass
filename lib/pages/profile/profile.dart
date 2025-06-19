import 'package:flutter/material.dart';
import '../../themes/colors/colors.dart';
import 'package:go_router/go_router.dart';
import '../../apps/router/router_name.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:metropass/pages/profile/profile_transaction.dart';

/// Main profile page displaying user information and navigation menu
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.pr1);
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.goNamed(RouterName.home);
              }
            },
          ),
          title: Text(
            AppLocalizations.of(context)!.profile,
            style: TextStyle(
              color: textColor,
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
            child: Container(
              height: 1,
              color: isDarkMode ? Colors.grey[500] : const Color(MyColor.pr8),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),
            // User profile section with avatar, name and role
            Center(
              child: Consumer<AuthController>(
                builder: (context, authController, _) {
                  final userModel = authController.userModel;
                  final firebaseUser = authController.firebaseUser;
                  String? avatarUrl;
                  if (userModel != null) {
                    // Prioritize Google avatar if available, otherwise use user's photo URL
                    avatarUrl =
                        firebaseUser?.photoURL?.isNotEmpty == true
                            ? firebaseUser!.photoURL
                            : (userModel.photoURL.isNotEmpty
                                ? userModel.photoURL
                                : null);
                  }
                  // Display loading skeleton while fetching user data
                  if (authController.isLoading && userModel == null) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDarkMode
                                  ? Colors.black
                                  : const Color(MyColor.white),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              isDarkMode
                                  ? Border.all(
                                    color: Colors.grey[600]!,
                                    width: 1,
                                  )
                                  : null,
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
                  if (userModel == null) {
                    // Hide profile section if no user data is available
                    return const SizedBox.shrink();
                  }
                  // Display user profile information
                  return GestureDetector(
                    onTap: () => context.goNamed(RouterName.profileInformation),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? Colors.black
                                : const Color(MyColor.white),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            isDarkMode
                                ? Border.all(color: Colors.grey[600]!, width: 1)
                                : null,
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
                                userModel.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: textColor,
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
            // Navigation menu items
            _ProfileMenuItem(
              icon: Icons.person,
              text: AppLocalizations.of(context)!.personalInfo,
              onTap: () => context.goNamed(RouterName.profileInformation),
            ),
            _ProfileMenuItem(
              icon: Icons.confirmation_num,
              text: AppLocalizations.of(context)!.myTickets,
              onTap: () => context.pushNamed(RouterName.profileTicket),
            ),
            _ProfileMenuItem(
              icon: Icons.history,
              text: AppLocalizations.of(context)!.transactionHistory,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileTransactionPage(),
                  ),
                );
              },
            ),
            _ProfileMenuItem(
              icon: Icons.settings,
              text: AppLocalizations.of(context)!.settings,
              onTap: () => context.pushNamed(RouterName.profileSetting),
            ),
          ],
        ),
      ),
    );
  }
}

/// Menu item widget for profile navigation
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.black : const Color(MyColor.white);
    final textColor = isDarkMode ? Colors.white : const Color(MyColor.pr9);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:
                  isDarkMode
                      ? Border.all(color: Colors.grey[600]!, width: 1)
                      : null,
            ),
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color:
                      isDarkMode ? Colors.grey[400] : const Color(MyColor.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
