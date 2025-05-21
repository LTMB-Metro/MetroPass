import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> registerUser({
    required String email,
    required String password,
    required String username,
    required String phonenumber,
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
          phonenumber: phonenumber,
          photoURL: "https://cdn-icons-png.freepik.com/512/3607/3607444.png",
          role: "user",
        );

        await _db.collection("users").doc(user.uid).set(userModel.toMap());
        return user;
      }
    } catch (e) {
      print("Đăng ký thất bại: $e");
      return null;
    }
    return null;
  }
}
