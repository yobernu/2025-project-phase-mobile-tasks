import 'dart:async';

import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/check_out_status_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_event.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SignUpUseCase signUpUseCase;
  final LoginUseCase loginUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final InternetConnectionChecker connectionChecker;

  UserBloc({
    required this.signUpUseCase,
    required this.loginUseCase,
    required this.checkAuthStatusUseCase,
    required this.getCurrentUserUseCase,
    required this.connectionChecker,
  }) : super(UserInitialState()) {
    on<SignUpRequestedEvent>(_onSignUp);
    on<LogInRequestedEvent>(_onLogIn);
    on<CheckAuthenticationStatusEvent>(_onCheckAuthStatus);
  }

  User? _currentUser;
  Timer? _sessionTimer;

  Future<void> _onSignUp(
    SignUpRequestedEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoadingState());

      if (!await connectionChecker.hasConnection) {
        emit(UserFailureState(ServerFailure('No internet connection')));
        return;
      }

      final result = await signUpUseCase(
        SignupUParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );

      result.fold((failure) => emit(UserFailureState(failure)), (user) {
        _currentUser = user;
        emit(UserSignUpSuccessState(user));
        // emit(UserLoggedInState(user));
        _startSessionTimer();
      });
    } catch (e) {
      emit(UserFailureState(ServerFailure('An unexpected error occurred')));
    }
  }

  Future<void> _onLogIn(
    LogInRequestedEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoadingState());

      if (!await connectionChecker.hasConnection) {
        emit(UserFailureState(ServerFailure('No internet connection')));
        return;
      }

      final result = await loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );

      result.fold((failure) => emit(UserFailureState(failure)), (user) {
        _currentUser = user;
        emit(UserLogInSuccessState(user));
        _startSessionTimer();
      });
    } catch (e) {
      emit(UserFailureState(ServerFailure('Login failed. Please try again.')));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthenticationStatusEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoadingState());

      final result = await checkAuthStatusUseCase(NoParams());

      if (result) {
        final userResult = await getCurrentUserUseCase(NoParams());

        userResult.fold((failure) => emit(UserUnauthenticatedState()), (user) {
          _currentUser = user;
          emit(UserLoggedInState(user));
          _startSessionTimer();
        });
      } else {
        emit(UserUnauthenticatedState());
      }
    } catch (e) {
      emit(UserUnauthenticatedState());
    }
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(const Duration(minutes: 30), () {
      if (_currentUser != null) {
        add(SignOutRequestedEvent(userId: _currentUser!.id));
      }
    });
  }

  @override
  Future<void> close() {
    _sessionTimer?.cancel();
    return super.close();
  }
}
