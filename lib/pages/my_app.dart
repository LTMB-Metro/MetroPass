import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../apps/router/router.dart';
import '../controllers/auth_controller.dart';
import '../controllers/password_reset_controller.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => PasswordResetController()),
      ],
      child: MaterialApp.router(
        title: 'MetroPass',
        debugShowCheckedModeBanner: false,
        routerConfig: RouterCustom.router,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      ),
    );
  }
}
