
import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';

class UserModel extends User{
  const UserModel({
    String? id,
    String? name,
    String? email,
    String? role,
    String? accessToken,
  }) : super(
    id: id ?? '0',
    name: name ?? '',
    email: email ?? '',
    role: role ?? '',
    accessToken: accessToken ?? '0',
    );


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      accessToken: json['accessToken']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'accessToken': accessToken
    };
  }
}