import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../apps/router/router_name.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading }

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AuthStatus _status = AuthStatus.unknown;
  User? _firebaseUser;
  UserModel? _userModel;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _isLoading;

  AuthController() {
    _initAuthListener();
  }

  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      print('Bắt đầu đăng ký người dùng với email: $email');
      final result = await _authService.registerWithEmailAndPassword(
        email,
        password,
        username,
        context,
      );

      if (result.success) {
        print('Đăng ký thành công cho email: $email');
        _setError(null);
        _setLoading(false);
        return true;
      } else {
        print('Đăng ký thất bại: ${result.message}');
        _setError(result.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('Lỗi khi đăng ký: $e');
      _setError('Lỗi đăng ký: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      print('Bắt đầu đăng nhập với email: $email');
      final result = await _authService.signInWithEmailAndPassword(
        email,
        password,
        context,
      );

      if (result.success) {
        print('Đăng nhập thành công cho email: $email');
        if (rememberMe) {
          print('Lưu thông tin đăng nhập');
          await _storageService.saveLoginCredentials(
            email: email,
            password: password,
            rememberMe: true,
          );
          await StorageService().updateLastOpenTime();
        }

        context.goNamed(RouterName.home);
        _setError(null);
        _setLoading(false);
        return true;
      } else {
        print('Đăng nhập thất bại: ${result.message}');
        _setError(result.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('Lỗi khi đăng nhập: $e');
      _setError('Lỗi đăng nhập: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle({required BuildContext context}) async {
    _setLoading(true);
    _clearError();

    try {
      print('Bắt đầu đăng nhập Google');
      final result = await _authService.signInWithGoogle(context);

      if (result.success) {
        print('Đăng nhập Google thành công');
        context.goNamed(RouterName.home);
        _setError(null);
        _setLoading(false);
        await StorageService().updateLastOpenTime();
        return true;
      } else {
        print('Đăng nhập Google thất bại: ${result.message}');
        _setError(result.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('Lỗi khi đăng nhập Google: $e');
      _setError('Lỗi đăng nhập Google: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Sign out current user
  Future<bool> signOut() async {
    _setLoading(true);

    try {
      print('Bắt đầu đăng xuất');
      await _authService.signOut();
      await _storageService.clearLoginCredentials();

      _firebaseUser = null;
      _userModel = null;
      _status = AuthStatus.unauthenticated;
      _clearError();
      _setLoading(false);

      print('Đăng xuất thành công');
      return true;
    } catch (e) {
      print('Lỗi khi đăng xuất: $e');
      _setError('Lỗi đăng xuất: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? username,
    String? phonenumber,
    String? photoURL,
    String? birthday,
    String? cccd,
  }) async {
    if (_firebaseUser == null || _userModel == null) return false;

    _setLoading(true);

    try {
      print('Bắt đầu cập nhật thông tin người dùng');
      final updatedUser = _userModel!.copyWith(
        username: username ?? _userModel!.username,
        phonenumber: phonenumber ?? _userModel!.phonenumber,
        photoURL: photoURL ?? _userModel!.photoURL,
        birthday: birthday ?? _userModel!.birthday,
        cccd: cccd ?? _userModel!.cccd,
      );

      await _db
          .collection('users')
          .doc(_firebaseUser!.uid)
          .update(updatedUser.toMap());

      if (username != null && username != _userModel!.username) {
        await _firebaseUser!.updateDisplayName(username);
        print('Cập nhật tên hiển thị Firebase Auth thành công');
      }

      _userModel = updatedUser;
      _clearError();
      _setLoading(false);

      print('Cập nhật thông tin người dùng thành công');
      return true;
    } catch (e) {
      print('Lỗi khi cập nhật thông tin: $e');
      _setError('Lỗi cập nhật thông tin: $e');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _status = AuthStatus.loading;
    }
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() => _clearError();

  void _initAuthListener() {
    _authService.authStateChanges.listen((User? user) {
      if (user != null) {
        print('Auth state changed: User logged in - ${user.uid}');
        _firebaseUser = user;
        _loadUserData(user.uid);
      } else {
        print('Auth state changed: User logged out');
        _firebaseUser = null;
        _userModel = null;
        _status = AuthStatus.unauthenticated;
        _clearError();
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      _setLoading(true);
      print('Tải dữ liệu người dùng cho UID: $uid');

      final userModel = await _authService.getUserData(uid);

      if (userModel != null) {
        _userModel = userModel;
        _status = AuthStatus.authenticated;
        _clearError();
        print('Tải dữ liệu người dùng thành công');
      } else {
        print('Dữ liệu người dùng không tồn tại, đăng xuất');
        await signOut();
        _setError('Dữ liệu người dùng không tồn tại');
      }
    } catch (e) {
      print('Lỗi khi tải dữ liệu người dùng: $e');
      _status = AuthStatus.unauthenticated;
      _setError('Lỗi tải dữ liệu người dùng: $e');
    }

    _setLoading(false);
  }

  /// Get saved login credentials
  Future<LoginCredentials> getSavedCredentials() async {
    return await _storageService.getLoginCredentials();
  }

  /// Reload user data from Firestore
  Future<void> reloadUserData() async {
    if (_firebaseUser != null) {
      print('Tải lại dữ liệu người dùng');
      await _loadUserData(_firebaseUser!.uid);
    }
  }
  
  Future<void> autoLogoutSilently() async {
    print('=== autologout');
    final shouldLogout = await _storageService.shouldAutoLogout();
    if (shouldLogout) {
      print('🕒 Đã quá 7 ngày không dùng app → auto logout (không điều hướng)');
      await signOut(); // Xoá phiên đăng nhập
    }
  }

}
