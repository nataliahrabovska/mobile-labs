import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../services/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final success = await _authService.login(email, password);
    if (success) {
      emit(AuthAuthenticated());
    } else {
      emit(const AuthError('Invalid credentials'));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authService.register(email, password);
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }

  Future<void> checkLoginStatus() async {
    final loggedIn = await _authService.isLoggedIn();
    emit(loggedIn ? AuthAuthenticated() : AuthUnauthenticated());
  }

  Future<void> logout() async {
    await _authService.logout();
    emit(AuthUnauthenticated());
  }
}
