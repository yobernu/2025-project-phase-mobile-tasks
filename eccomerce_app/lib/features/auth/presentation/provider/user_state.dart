import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';

abstract class UserState {}

class UserInitialState extends UserState {
  UserInitialState();
}

class UserLoadingState extends UserState {}

class UserSuccessState extends UserState {
  final User user;

  UserSuccessState(this.user);
}

class UserSignUpSuccessState extends UserState {
  final User user;
  UserSignUpSuccessState(this.user);
}

class UserLoggedInState extends UserState {
  final User user;
  
  UserLoggedInState(this.user);
}


class UserTokenRefreshFailedState extends UserState {
  final String message;
  UserTokenRefreshFailedState(this.message);
}





class UserSignedOutState extends UserState {}


class UserAuthenticatedState extends UserState {
  final User user;
  
  UserAuthenticatedState(this.user);
  
  @override
  List<Object> get props => [user];
}

class UserUnauthenticatedState extends UserState {}




class UserFailureState extends UserState {
  final Failure failure;
  
  UserFailureState(this.failure);
}