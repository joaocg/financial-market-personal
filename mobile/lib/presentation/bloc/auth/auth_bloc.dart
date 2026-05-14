import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/auth/biometric_helper.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/models/user.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class BiometricUnlockRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final BiometricHelper _biometricHelper;

  AuthBloc(
      {required AuthRepository authRepository,
      required BiometricHelper biometricHelper})
      : _authRepository = authRepository,
        _biometricHelper = biometricHelper,
        super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.login(
            email: event.email, password: event.password);
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(AuthFailure('Credenciais invalidas'));
        }
      } on AuthException catch (e) {
        emit(AuthFailure(e.message));
      } catch (_) {
        emit(AuthFailure('Nao foi possivel autenticar'));
      }
    });

    on<BiometricUnlockRequested>((event, emit) async {
      final authenticated = await _biometricHelper.authenticate();
      if (authenticated) {
        // Here we'd typically have the user already stored or tokens available
        // Simplified for now
      } else {
        emit(AuthFailure('Biometric authentication failed'));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    });
  }
}
