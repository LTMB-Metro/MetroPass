
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metropass/pages/welcome/welcome_page.dart';
import 'package:metropass/apps/router/router_name.dart';

class RouterCustum{
  static final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: RouterName.welcome,
      builder: (BuildContext context, GoRouterState state) {
        return const WelcomePage();
      },
      // routes: <RouteBase>[
      //   GoRoute(
      //     path: 'login',
      //     name: RouterName.login,
      //     builder: (BuildContext context, GoRouterState state) {
      //       return const LoginPage();
      //     },
      //     routes: [
      //       GoRoute(
      //         path: 'register',
      //         name: RouterName.register,
      //         builder: (BuildContext context, GoRouterState state) {
      //           return const RegisterPage();
      //         },
      //       ),
      //       GoRoute(
      //         path: 'forgotPassword',
      //         name: RouterName.forgotPassword,
      //         builder: (BuildContext context, GoRouterState state) {
      //           return const ForgotPasswordPage();
      //         },
      //       ),
      //     ]
      //   ),
      // ],
    ),
  ],
);
}