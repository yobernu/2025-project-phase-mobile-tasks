import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? role;
  final String? accessToken;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String?,
      accessToken: json['access_token'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'access_token': accessToken
    };
  }

  @override
  List<Object?> get props => [id, name, email, role, accessToken];
}