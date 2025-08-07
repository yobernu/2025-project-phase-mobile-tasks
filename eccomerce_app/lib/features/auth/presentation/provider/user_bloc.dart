import 'package:ecommerce_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_event.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<SignUpRequested>(_onSignUp);
    on<LogInRequested>(_onLogIn);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onSignUp(SignUpRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await userRepository.signUp(
      name: event.name,
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(UserFailure(failure.toString())),
      (user) => emit(UserSuccess(user)),
    );
  }

  Future<void> _onLogIn(LogInRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await userRepository.logIn(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(UserFailure(failure.toString())),
      (user) => emit(UserSuccess(user)),
    );
  }

  Future<void> _onSignOut(SignOutRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await userRepository.signOut(
      id: event.userId
      );

    result.fold(
      (failure) => emit(UserFailure(failure.toString())),
      (_) => emit(UserSignedOut()),
    );
  }
}