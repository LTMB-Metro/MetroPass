import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Register with email and password
  Future<AuthResult> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
    BuildContext context,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(username);
        await _createUserDocument(userCredential.user!, email, username);
        return AuthResult.success(
          message: AppLocalizations.of(context)!.registerSuccess,
          user: userCredential.user,
        );
      }
      return AuthResult.failure(AppLocalizations.of(context)!.registerFailed);
    } on FirebaseAuthException catch (e) {
      print('Lỗi Firebase Auth khi đăng ký: ${e.code}');
      return AuthResult.failure(_getAuthErrorMessage(e.code, context));
    } catch (e) {
      print('Lỗi chung khi đăng ký: $e');
      return AuthResult.failure(AppLocalizations.of(context)!.registerFailed);
    }
  }

  /// Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success(
        message: AppLocalizations.of(context)!.loginSuccess,
        user: userCredential.user,
      );
    } on FirebaseAuthException catch (e) {
      print('Lỗi Firebase Auth khi đăng nhập: ${e.code}');
      return AuthResult.failure(_getAuthErrorMessage(e.code, context));
    } catch (e) {
      print('Lỗi chung khi đăng nhập: $e');
      return AuthResult.failure(AppLocalizations.of(context)!.loginFailed);
    }
  }

  /// Sign in with Google
  Future<AuthResult> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult.failure(
          AppLocalizations.of(context)!.googleSignInFailed,
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        return AuthResult.failure(
          AppLocalizations.of(context)!.googleSignInFailed,
        );
      }

      // Check if user profile exists in Firestore
      final userDoc = await _db.collection("users").doc(user.uid).get();
      if (!userDoc.exists) {
        // Create new user profile
        final userModel = UserModel(
          email: user.email ?? '',
          username: user.displayName ?? '',
          phonenumber: '',
          photoURL:
              user.photoURL ??
              "https://img.lovepik.com/free-png/20211204/lovepik-cartoon-avatar-png-image_401302777_wh1200.png",
          createdAt: DateTime.now(),
        );
        await _db.collection("users").doc(user.uid).set(userModel.toMap());
        print('Tạo tài liệu người dùng mới cho UID: \\${user.uid}');
      }

      return AuthResult.success(
        message: AppLocalizations.of(context)!.googleSignInSuccess,
        user: user,
      );
    } on FirebaseAuthException catch (e) {
      print('Lỗi Firebase Auth khi đăng nhập Google: \\${e.code}');
      return AuthResult.failure(_getAuthErrorMessage(e.code, context));
    } catch (e) {
      print('Lỗi chung khi đăng nhập Google: \\${e}');
      return AuthResult.failure(
        AppLocalizations.of(context)!.googleSignInFailed,
      );
    }
  }

  /// Reset password
  Future<Map<String, dynamic>> resetPassword(
    String email,
    BuildContext context,
  ) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': AppLocalizations.of(context)!.otpSent,
      };
    } on FirebaseAuthException catch (e) {
      print('Lỗi Firebase Auth khi đặt lại mật khẩu: ${e.code}');
      return {
        'success': false,
        'message': _getAuthErrorMessage(e.code, context),
      };
    } catch (e) {
      print('Lỗi chung khi đặt lại mật khẩu: $e');
      return {
        'success': false,
        'message': AppLocalizations.of(context)!.otpSendFailed,
      };
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        print('Đăng xuất Google');
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
      print('Đăng xuất thành công');
    } catch (e) {
      print('Lỗi khi đăng xuất: $e');
      throw Exception('Lỗi đăng xuất: $e');
    }
  }

  User? getCurrentUser() => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection("users").doc(uid).get();
      if (doc.exists) {
        print('Lấy dữ liệu người dùng thành công cho UID: $uid');
        return UserModel.fromSnapshot(doc);
      }
      print('Không tìm thấy dữ liệu người dùng cho UID: $uid');
      return null;
    } catch (e) {
      print('Lỗi khi lấy dữ liệu người dùng: $e');
      throw Exception('Lỗi lấy dữ liệu người dùng: $e');
    }
  }

  /// Create user document in Firestore
  Future<void> _createUserDocument(
    User user,
    String email,
    String username,
  ) async {
    try {
      final userModel = UserModel(
        email: email,
        username: username,
        phonenumber: "",
        photoURL:
            user.photoURL ??
            "https://img.lovepik.com/free-png/20211204/lovepik-cartoon-avatar-png-image_401302777_wh1200.png",
      );

      await _db.collection("users").doc(user.uid).set(userModel.toMap());
      print('Tạo tài liệu người dùng thành công cho UID: ${user.uid}');
    } catch (e) {
      print('Lỗi khi tạo tài liệu người dùng: $e');
      throw e;
    }
  }

  /// Get localized error messages
  String _getAuthErrorMessage(String code, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (code) {
      case 'weak-password':
        return l10n.authErrorWeakPassword;
      case 'email-already-in-use':
        return l10n.authErrorEmailInUse;
      case 'invalid-email':
        return l10n.authErrorInvalidEmail;
      case 'user-not-found':
        return l10n.authErrorUserNotFound;
      case 'wrong-password':
        return l10n.authErrorWrongPassword;
      case 'invalid-credential':
        return l10n.authErrorInvalidCredential;
      case 'too-many-requests':
        return l10n.authErrorTooManyRequests;
      default:
        return l10n.authErrorGeneric(code);
    }
  }
}

/// Result wrapper for auth operations
class AuthResult {
  final bool success;
  final String message;
  final User? user;

  AuthResult._({required this.success, required this.message, this.user});

  factory AuthResult.success({required String message, User? user}) {
    return AuthResult._(success: true, message: message, user: user);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(success: false, message: message);
  }
}
