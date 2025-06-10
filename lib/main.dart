import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:metropass/pages/my_app.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

/// Main entry point of the application
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WebViewPlatform.instance = AndroidWebViewPlatform();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  await dotenv.load(fileName: ".env");
  final token = dotenv.env['MAPBOX_ACCESS_TOKEN'];
  if (token == null || token.isEmpty) {
    throw Exception("MAPBOX_ACCESS_TOKEN is missing in .env file");
  }
  MapboxOptions.setAccessToken(token);
  await Firebase.initializeApp();
  runApp(const MyApp());
}
