import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../apps/router/router.dart';
import '../controllers/auth_controller.dart';
import '../controllers/password_reset_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../themes/theme_provider.dart';
import '../services/storage_service.dart';

/// Provider class for managing application locale
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('vi');
  final StorageService _storageService = StorageService();

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  /// Load saved locale from storage
  Future<void> _loadSavedLocale() async {
    try {
      final savedLocale = await _storageService.getLocale();
      if (savedLocale != null) {
        _locale = Locale(savedLocale);
        notifyListeners();
      } else {
        // If no saved locale, try to detect system locale
        await _detectSystemLocale();
      }
    } catch (e) {
      // Fallback to Vietnamese
      _locale = const Locale('vi');
      notifyListeners();
    }
  }

  /// Detect system locale and set appropriate language
  Future<void> _detectSystemLocale() async {
    try {
      // Use Platform.localeName to get system locale
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      if (systemLocale.languageCode == 'vi') {
        _locale = const Locale('vi');
      } else {
        _locale = const Locale('en');
      }
      notifyListeners();
    } catch (e) {
      // Fallback to Vietnamese
      _locale = const Locale('vi');
      notifyListeners();
    }
  }

  /// Set locale and save to storage
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    // Save to storage
    try {
      await _storageService.saveLocale(locale.languageCode);
    } catch (e) {
      print('Failed to save locale: $e');
    }
  }
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => PasswordResetController()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, localeProvider, themeProvider, child) {
          return MaterialApp.router(
            title: 'MetroPass',
            debugShowCheckedModeBanner: false,
            routerConfig: RouterCustom.router,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black),
                bodyMedium: TextStyle(color: Colors.black),
                titleLarge: TextStyle(color: Colors.black),
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
                titleLarge: TextStyle(color: Colors.white),
              ),
            ),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('vi'), Locale('en')],
          );
        },
      ),
    );
  }
}
