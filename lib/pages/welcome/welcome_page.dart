import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metropass/apps/router/router_name.dart';
import 'package:metropass/controllers/auth_controller.dart';
import 'package:metropass/services/storage_service.dart';
import 'package:provider/provider.dart';
import '../../themes/colors/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = Provider.of<AuthController>(context, listen: false);

      await Future.delayed(const Duration(seconds: 1));
      await auth.autoLogoutSilently();

      if (!mounted) return;

      // ✅ Chờ tối đa 3 giây để status chuyển sang authenticated
      for (int i = 0; i < 30; i++) {
        if (auth.status == AuthStatus.authenticated || auth.status == AuthStatus.unauthenticated) {
          break;
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (!mounted) return;

      if (auth.status == AuthStatus.authenticated) {
        await StorageService().updateLastOpenTime();
        context.goNamed(RouterName.home);
      } else {
        context.goNamed(RouterName.login);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    print('===== welcome');
    return PopScope(
      canPop: false, 
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.exitApp),
              content: Text(AppLocalizations.of(context)!.exitAppConfirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.exit,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        // Set background
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(MyColor.pr2), Color(MyColor.white)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          // Logo
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/images/logo.png', height: 30),
                  const Spacer(),
                  // Welcome image
                  Container(
                    width: 280,
                    height: 280,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(MyColor.pr7),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/welcome.png',
                        width: 260,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Text
                  Text(
                    AppLocalizations.of(context)!.welcomeSlogan1,
                    style: TextStyle(
                      color: Color(MyColor.pr8),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.welcomeSlogan2,
                    style: TextStyle(color: Color(MyColor.pr8), fontSize: 16),
                  ),
                  const Spacer(),
                  // Button start
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 40),
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: _buildStartButton(context),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Start button widget
  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.goNamed(RouterName.login),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(MyColor.pr8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        AppLocalizations.of(context)!.start,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
