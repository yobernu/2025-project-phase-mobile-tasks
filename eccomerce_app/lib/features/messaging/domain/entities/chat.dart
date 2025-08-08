import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';

class Chat {
  final String id;
  final User user1;
  final User user2;

  Chat({
    required this.id,
    required this.user1,
    required this.user2,
  });
}