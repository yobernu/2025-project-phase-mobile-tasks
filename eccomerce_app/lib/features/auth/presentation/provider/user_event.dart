abstract class UserEvent {}

class SignUpRequested extends UserEvent {
  final String name;
  final String email;
  final String password;

  SignUpRequested({required this.name, required this.email, required this.password});
}

class LogInRequested extends UserEvent {
  final String email;
  final String password;

  LogInRequested({required this.email, required this.password});
}

class SignOutRequested extends UserEvent {
  final int userId;

  SignOutRequested({required this.userId});
}