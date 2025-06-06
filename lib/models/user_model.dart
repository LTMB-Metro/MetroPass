import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String phonenumber;
  final String photoURL;
  final String role;
  final DateTime? createdAt;
  final String birthday;
  final String cccd;

  UserModel({
    required this.email,
    required this.username,
    required this.phonenumber,
    required this.photoURL,
    required this.role,
    this.createdAt,
    this.birthday = '',
    this.cccd = '',
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
      'birthday': birthday,
      'cccd': cccd,
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
      birthday: map['birthday'] ?? '',
      cccd: map['cccd'] ?? '',
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
    String? birthday,
    String? cccd,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username ?? this.username,
      phonenumber: phonenumber ?? this.phonenumber,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      birthday: birthday ?? this.birthday,
      cccd: cccd ?? this.cccd,
    );
  }

  @override
  String toString() {
    return 'UserModel(email: $email, username: $username, phonenumber: $phonenumber, photoURL: $photoURL, role: $role, createdAt: $createdAt)';
  }
}
