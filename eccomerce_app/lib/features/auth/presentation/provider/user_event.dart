import 'package:equatable/equatable.dart';



abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequestedEvent extends UserEvent {
  final String name;
  final String email;
  final String password;

  const SignUpRequestedEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}



class LogInRequestedEvent extends UserEvent {
  final String email;
  final String password;

  const LogInRequestedEvent({required this.email, required this.password});
}

class SignOutRequestedEvent extends UserEvent {
  final String userId;

  const SignOutRequestedEvent({required this.userId});
}

class CheckAuthenticationStatusEvent extends UserEvent {}

class RefreshTokenEvent extends UserEvent {}