import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Register new user with email/password
  Future<AuthResult> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      if (user != null) {
        final userModel = UserModel(
          email: email,
          username: username,
          phonenumber: "", 
          photoURL: "https://img.lovepik.com/free-png/20211204/lovepik-cartoon-avatar-png-image_401302777_wh1200.png",
          role: "user",
        );

        await _db.collection("users").doc(user.uid).set(userModel.toMap());
        await user.updateDisplayName(username);
        await user.reload();
        await _auth.signOut();

        return AuthResult.success(
          message: 'Đăng ký thành công! Vui lòng đăng nhập.',
          user: user,
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Lỗi Firebase Auth khi đăng ký: ${e.code}');
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      print('Lỗi chung khi đăng ký: $e');
      return AuthResult.failure('Đã xảy ra lỗi: $e');
    }

    return AuthResult.failure('Đăng ký thất bại');
  }

  /// Sign in with email/password
  Future<AuthResult> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        DocumentSnapshot userDoc = await _db.collection("users").doc(user.uid).get();
        
        if (!userDoc.exists) {
          print('Tài liệu người dùng không tồn tại, tạo mới');
          await _createUserDocument(user, email);
        }
        
        return AuthResult.success(
          message: 'Đăng nhập thành công',
          user: user,
        );
      }
      
      return AuthResult.failure('Đăng nhập thất bại');
      
    } on FirebaseAuthException catch (e) {
      print('Lỗi Firebase Auth khi đăng nhập: ${e.code}');
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      print('Lỗi chung khi đăng nhập: $e');
      return AuthResult.failure('Đã xảy ra lỗi: $e');
    }
  }

  /// Sign in with Google account
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('Người dùng hủy đăng nhập Google');
        return AuthResult.failure('Đăng nhập bị hủy');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        DocumentSnapshot userDoc = await _db.collection("users").doc(user.uid).get();
        
        if (!userDoc.exists) {
          print('Tài liệu người dùng Google không tồn tại, tạo mới');
          await _createUserDocument(user, user.email ?? '');
        }

        return AuthResult.success(
          message: 'Đăng nhập Google thành công',
          user: user,
        );
      }

      return AuthResult.failure('Đăng nhập Google thất bại');

    } on FirebaseAuthException catch (e) {
      print('Lỗi Firebase Auth khi đăng nhập Google: ${e.code}');
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      print('Lỗi chung khi đăng nhập Google: $e');
      return AuthResult.failure('Đã xảy ra lỗi: $e');
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

  /// Send password reset email
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Email đặt lại mật khẩu đã được gửi đến: $email');
      return {
        'success': true,
        'message': 'Email đặt lại mật khẩu đã được gửi',
      };
    } on FirebaseAuthException catch (e) {
      print('Lỗi Firebase Auth khi đặt lại mật khẩu: ${e.code}');
      return {
        'success': false,
        'message': _getAuthErrorMessage(e.code),
      };
    } catch (e) {
      print('Lỗi chung khi đặt lại mật khẩu: $e');
      return {
        'success': false,
        'message': 'Đã xảy ra lỗi: $e',
      };
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
  Future<void> _createUserDocument(User user, String email) async {
    try {
      final userModel = UserModel(
        email: email,
        username: user.displayName ?? 'Người dùng',
        phonenumber: "",
        photoURL: user.photoURL ?? "https://img.lovepik.com/free-png/20211204/lovepik-cartoon-avatar-png-image_401302777_wh1200.png",
        role: "user",
      );
      
      await _db.collection("users").doc(user.uid).set(userModel.toMap());
      print('Tạo tài liệu người dùng thành công cho UID: ${user.uid}');
    } catch (e) {
      print('Lỗi khi tạo tài liệu người dùng: $e');
      throw e;
    }
  }

  /// Get localized error messages
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Mật khẩu quá yếu';
      case 'email-already-in-use':
        return 'Email đã được đăng ký';
      case 'invalid-email':
        return 'Định dạng email không hợp lệ';
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này';
      case 'wrong-password':
        return 'Mật khẩu không chính xác';
      case 'invalid-credential':
        return 'Email hoặc mật khẩu không hợp lệ';
      case 'too-many-requests':
        return 'Quá nhiều lần thử. Vui lòng thử lại sau';
      default:
        return 'Lỗi xác thực: $code';
    }
  }
}

/// Result wrapper for auth operations
class AuthResult {
  final bool success;
  final String message;
  final User? user;

  AuthResult._({
    required this.success,
    required this.message,
    this.user,
  });

  factory AuthResult.success({required String message, User? user}) {
    return AuthResult._(success: true, message: message, user: user);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(success: false, message: message);
  }
}