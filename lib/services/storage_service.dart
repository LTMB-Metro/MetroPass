import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  static const String _lastOpenKey = 'last_open_time';

  /// Save login credentials to local storage
  Future<void> saveLoginCredentials({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      print('Bắt đầu lưu thông tin đăng nhập');
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool(_rememberMeKey, rememberMe);
      print('Lưu trạng thái "Ghi nhớ đăng nhập": $rememberMe');
      
      if (rememberMe) {
        await prefs.setString(_savedEmailKey, email);
        await prefs.setString(_savedPasswordKey, password);
        print('Lưu thông tin đăng nhập thành công cho email: $email');
      } else {
        await prefs.remove(_savedEmailKey);
        await prefs.remove(_savedPasswordKey);
        print('Xóa thông tin đăng nhập đã lưu');
      }
    } catch (e) {
      print('Lỗi khi lưu thông tin đăng nhập: $e');
      throw Exception('Lỗi lưu thông tin đăng nhập: $e');
    }
  }

  Future<void> updateLastOpenTime() async {
    print('==== update');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastOpenKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> shouldAutoLogout() async {
    print('==== should');
    final prefs = await SharedPreferences.getInstance();
    final lastOpenMillis = prefs.getInt(_lastOpenKey);
    print('===🕒 last_open_time = $lastOpenMillis → ${DateTime.fromMillisecondsSinceEpoch(lastOpenMillis ?? 0)}');

    if (lastOpenMillis == null) return false;

    final lastOpenTime = DateTime.fromMillisecondsSinceEpoch(lastOpenMillis);
    final now = DateTime.now();
    final differenceInDays = now.difference(lastOpenTime).inDays;
      return differenceInDays >= 7;
      // final differenceInMinutes = now.difference(lastOpenTime).inMinutes;
      // return differenceInMinutes >= 5;
  }

  /// Get saved login credentials
  Future<LoginCredentials> getLoginCredentials() async {
    try {
      print('Lấy thông tin đăng nhập đã lưu');
      final prefs = await SharedPreferences.getInstance();
      
      final credentials = LoginCredentials(
        rememberMe: prefs.getBool(_rememberMeKey) ?? false,
        email: prefs.getString(_savedEmailKey) ?? '',
        password: prefs.getString(_savedPasswordKey) ?? '',
      );
      
      print('Lấy thông tin đăng nhập: Remember Me = ${credentials.rememberMe}, Has Credentials = ${credentials.hasCredentials}');
      return credentials;
    } catch (e) {
      print('Lỗi khi lấy thông tin đăng nhập: $e');
      return LoginCredentials(rememberMe: false, email: '', password: '');
    }
  }

  /// Clear all saved login credentials
  Future<void> clearLoginCredentials() async {
    try {
      print('Bắt đầu xóa tất cả thông tin đăng nhập');
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.remove(_rememberMeKey);
      await prefs.remove(_savedEmailKey);
      await prefs.remove(_savedPasswordKey);
      
      print('Xóa tất cả thông tin đăng nhập thành công');
    } catch (e) {
      print('Lỗi khi xóa thông tin đăng nhập: $e');
      throw Exception('Lỗi xóa thông tin đăng nhập: $e');
    }
  }

  /// Check if remember me is enabled
  Future<bool> isRememberMeEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_rememberMeKey) ?? false;
      print('Kiểm tra trạng thái "Ghi nhớ đăng nhập": $isEnabled');
      return isEnabled;
    } catch (e) {
      print('Lỗi khi kiểm tra trạng thái "Ghi nhớ đăng nhập": $e');
      return false;
    }
  }

  /// Generic method to save user preference
  Future<void> saveUserPreference(String key, dynamic value) async {
    try {
      print('Lưu tùy chọn người dùng: $key = $value');
      final prefs = await SharedPreferences.getInstance();
      
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else {
        print('Loại dữ liệu không được hỗ trợ: ${value.runtimeType}');
        throw Exception('Loại dữ liệu không được hỗ trợ');
      }
      
      print('Lưu tùy chọn người dùng thành công: $key');
    } catch (e) {
      print('Lỗi khi lưu tùy chọn người dùng: $e');
      throw Exception('Lỗi lưu tùy chọn: $e');
    }
  }

  /// Generic method to get user preference
  Future<T?> getUserPreference<T>(String key) async {
    try {
      print('Lấy tùy chọn người dùng: $key');
      final prefs = await SharedPreferences.getInstance();
      
      T? result;
      if (T == String) {
        result = prefs.getString(key) as T?;
      } else if (T == bool) {
        result = prefs.getBool(key) as T?;
      } else if (T == int) {
        result = prefs.getInt(key) as T?;
      } else if (T == double) {
        result = prefs.getDouble(key) as T?;
      } else {
        print('Loại dữ liệu không được hỗ trợ: $T');
      }
      
      print('Lấy tùy chọn người dùng: $key = $result');
      return result;
    } catch (e) {
      print('Lỗi khi lấy tùy chọn người dùng: $e');
      return null;
    }
  }

  /// Remove specific user preference
  Future<void> removeUserPreference(String key) async {
    try {
      print('Xóa tùy chọn người dùng: $key');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      print('Xóa tùy chọn người dùng thành công: $key');
    } catch (e) {
      print('Lỗi khi xóa tùy chọn người dùng: $e');
      throw Exception('Lỗi xóa tùy chọn: $e');
    }
  }

  /// Clear all stored data
  Future<void> clearAllData() async {
    try {
      print('Bắt đầu xóa tất cả dữ liệu đã lưu');
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('Xóa tất cả dữ liệu thành công');
    } catch (e) {
      print('Lỗi khi xóa tất cả dữ liệu: $e');
      throw Exception('Lỗi xóa tất cả dữ liệu: $e');
    }
  }

  /// Get all stored keys for debugging
  Future<Set<String>> getAllKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      print('Tất cả các key đã lưu: $keys');
      return keys;
    } catch (e) {
      print('Lỗi khi lấy danh sách key: $e');
      return <String>{};
    }
  }

  /// Check if a specific key exists
  Future<bool> containsKey(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final exists = prefs.containsKey(key);
      print('Kiểm tra key "$key" tồn tại: $exists');
      return exists;
    } catch (e) {
      print('Lỗi khi kiểm tra key: $e');
      return false;
    }
  }
}

/// Data class for login credentials
class LoginCredentials {
  final bool rememberMe;
  final String email;
  final String password;

  LoginCredentials({
    required this.rememberMe,
    required this.email,
    required this.password,
  });

  /// Check if credentials are available
  bool get hasCredentials => email.isNotEmpty && password.isNotEmpty;

  /// Convert to string for debugging
  @override
  String toString() {
    return 'LoginCredentials(rememberMe: $rememberMe, email: $email, hasPassword: ${password.isNotEmpty})';
  }
}