
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
    id: json['_id']?.toString() ?? '0',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? '', // optional
    accessToken: json['access_token'] ?? '', // optional
  );
}

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'accessToken': accessToken
    };
  }
}