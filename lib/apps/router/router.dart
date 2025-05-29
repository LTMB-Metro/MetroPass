import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metropass/pages/book_ticket/book_ticket_page.dart';
import 'package:metropass/pages/book_ticket/stations_route_page.dart';
import 'package:metropass/pages/home/home_page.dart';
import 'package:metropass/pages/payment/payment_page.dart';
import 'package:metropass/pages/welcome/welcome_page.dart';
import 'package:metropass/pages/login/login.dart';
import 'package:metropass/pages/register/register.dart';
import 'package:metropass/pages/forget_password/forgetpassword.dart';
import 'package:metropass/pages/forget_password/verification.dart';
import 'package:metropass/apps/router/router_name.dart';
import 'package:metropass/widgets/skeleton/ticket_card_skeleton.dart';
import 'package:metropass/widgets/ticket_normal_list.dart';
import '../../pages/welcome/welcome_page.dart';
import '../../pages/profile/profile.dart';
import 'package:metropass/pages/profile/profile_infomation.dart';
import 'package:metropass/pages/profile/profile_ticket.dart';
import 'package:metropass/pages/profile/profile_setting.dart';

class RouterCustom {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: RouterName.welcome,
        builder: (BuildContext context, GoRouterState state) {
          return WelcomePage();
        },
      ),
      GoRoute(
        path: '/login',
        name: RouterName.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/register',
        name: RouterName.register,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: '/forgot-password',
        name: RouterName.forgotPassword,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordPage();
        },
      ),
      GoRoute(
        path: '/verification',
        name: RouterName.verification,
        builder: (BuildContext context, GoRouterState state) {
          return const VerificationPage();
        },
      ),
      GoRoute(
        path: '/home',
        name: RouterName.home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/profile-information',
        name: RouterName.profileInformation,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileInformationPage();
        },
      ),
      GoRoute(
        path: '/profile',
        name: RouterName.profile,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfilePage();
        },
      ),
      GoRoute(
        path: '/profile-ticket',
        name: RouterName.profileTicket,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileTicketPage();
        },
      ),
      GoRoute(
        path: '/profile-setting',
        name: RouterName.profileSetting,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileSettingPage();
        },
      ),
    ],
  );
}
