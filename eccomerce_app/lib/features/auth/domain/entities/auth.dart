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
    id: json['_id']?.toString() ?? '0',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? '', 
    accessToken: json['access_token'] ?? '', 
  );
}

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'access_token': accessToken
    };
  }

  @override
  List<Object?> get props => [id, name, email, role, accessToken];
}