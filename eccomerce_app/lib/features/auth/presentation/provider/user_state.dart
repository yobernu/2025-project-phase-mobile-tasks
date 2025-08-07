import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';

abstract class UserState {}

class UserInitial extends UserState {
}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final User user;

  UserSuccess(this.user);
}

class UserFailure extends UserState {
  final String message;

  UserFailure(this.message);
}

class UserSignedOut extends UserState {}