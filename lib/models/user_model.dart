import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String phonenumber;
  final String photoURL;
  final String role;
  final DateTime? createdAt;

  UserModel({
    required this.email,
    required this.username,
    required this.phonenumber,
    required this.photoURL,
    required this.role,
    this.createdAt,
  });

  /// Convert object to map for saving
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'phonenumber': phonenumber,
      'photoURL': photoURL,
      'role': role,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }

  /// Create UserModel from Map (from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      phonenumber: map['phonenumber'] ?? '',
      photoURL: map['photoURL'] ?? '',
      role: map['role'] ?? 'user',
      createdAt: map['createdAt']?.toDate(),
    );
  }

  /// Create UserModel from DocumentSnapshot
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  /// Copy with method to create copy with some changes
  UserModel copyWith({
    String? email,
    String? username,
    String? phonenumber,
    String? photoURL,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username ?? this.username,
      phonenumber: phonenumber ?? this.phonenumber,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(email: $email, username: $username, phonenumber: $phonenumber, photoURL: $photoURL, role: $role, createdAt: $createdAt)';
  }
}