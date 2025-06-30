import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String phonenumber;
  final String photoURL;
  final DateTime? createdAt;
  final String birthday;
  final String cccd;
  final String role;

  UserModel({
    required this.email,
    required this.username,
    required this.phonenumber,
    required this.photoURL,
    this.createdAt,
    this.birthday = '',
    this.cccd = '',
    this.role = 'user',
  });

  /// Convert object to map for saving
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'phonenumber': phonenumber,
      'photoURL': photoURL,
      'createdAt': createdAt ?? DateTime.now(),
      'birthday': birthday,
      'cccd': cccd,
      'role': role,
    };
  }

  /// Create UserModel from Map (from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      phonenumber: map['phonenumber']?.toString() ?? '',
      photoURL: map['photoURL']?.toString() ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : (map['createdAt'] is String
              ? DateTime.tryParse(map['createdAt'])
              : null),
      birthday: map['birthday']?.toString() ?? '',
      cccd: map['cccd']?.toString() ?? '',
      role: map['role']?.toString() ?? 'user',
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
    DateTime? createdAt,
    String? birthday,
    String? cccd,
    String? role,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username ?? this.username,
      phonenumber: phonenumber ?? this.phonenumber,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      birthday: birthday ?? this.birthday,
      cccd: cccd ?? this.cccd,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'UserModel(email: $email, username: $username, phonenumber: $phonenumber, photoURL: $photoURL, createdAt: $createdAt, role: $role)';
  }
}
