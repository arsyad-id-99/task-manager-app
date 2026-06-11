import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/domain/repositories/auth_repository.dart';
import 'package:task_manager_app/domain/usecases/auth.dart';

// --- Events ---
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterRequested(this.name, this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

// --- States ---
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

// --- Bloc ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase.execute(event.email, event.password);
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (token) => emit(AuthSuccess()),
      );
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await registerUseCase.execute(
        event.name,
        event.email,
        event.password,
      );
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (token) => emit(AuthSuccess()),
      );
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.logout();
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (_) => emit(AuthInitial()),
      );
    });
  }
}
