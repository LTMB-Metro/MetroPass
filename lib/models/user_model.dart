class UserModel {
  final String email;
  final String username;
  final String phonenumber;
  final String photoURL;
  final String role;

  UserModel({
    required this.email,
    required this.username,
    required this.phonenumber,
    required this.photoURL,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'phonenumber': phonenumber,
      'photoURL': photoURL,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      phonenumber: map['phonenumber'] ?? '',
      photoURL: map['photoURL'] ?? '',
      role: map['role'] ?? '',
    );
  }
}
