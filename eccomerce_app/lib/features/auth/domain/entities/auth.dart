import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

    User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      role: role,
    );
  }

  @override
  List<Object?> get props => [id, name, email, role];
}