import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metropass/pages/book_ticket/book_ticket_page.dart';
import 'package:metropass/pages/home/home_page.dart';
import 'package:metropass/pages/welcome/welcome_page.dart';
import 'package:metropass/pages/login/login.dart';
import 'package:metropass/pages/register/register.dart';
import 'package:metropass/apps/router/router_name.dart';
import 'package:metropass/widgets/skeleton/ticket_card_skeleton.dart';
import 'package:metropass/widgets/ticket_normal_list.dart';

class RouterCustom {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: RouterName.welcome,
        builder: (BuildContext context, GoRouterState state) {
          return HomePage();
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
    ],
  );
}