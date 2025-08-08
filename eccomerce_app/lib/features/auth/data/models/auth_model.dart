
import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';

class UserModel extends User{
  const UserModel({
    int? id,
    String? name,
    String? email,
    String? role
  }) : super(
    id: id ?? 0,
    name: name ?? '',
    email: email ?? '',
    role: role ?? ''
    );


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role
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
}