import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../states/auth_state.dart';
import '../providers/auth_providers.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final AuthService _authService;
  bool _hasInitialized = false;

  @override
  AuthState build() {
    _authService = ref.watch(authServiceProvider);

    if (!_hasInitialized) {
      _hasInitialized = true;
      _checkInitialSession();
      _setupAuthStateListener();
    }

    return const AuthState.initial();
  }

  void _setupAuthStateListener() {
    _authService.authStateChanges.listen((session) {
      if (session == null) {
        if (state is AuthStateAuthenticated) {
          state = const AuthState.unauthenticated();
        }
      } else {
        if (state is AuthStateInitial || state is AuthStateError) {
          _checkInitialSession();
        }
      }
    });
  }

  Future<void> _checkInitialSession() async {
    state = const AuthState.loading();
    try {
      final usuario = await _authService.checkSession();
      if (usuario != null) {
        state = AuthState.authenticated(usuario);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = const AuthState.loading();
    try {
      final usuario = await _authService.login(email: email, password: password);
      state = AuthState.authenticated(usuario);
      return true;
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await _authService.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error('Erro ao fazer logout: ${e.toString()}');
      state = const AuthState.unauthenticated();
    }
  }

  Future<bool> resetPassword(String email, {String? redirectTo}) async {
    try {
      await _authService.resetPassword(email, redirectTo: redirectTo);
      return true;
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  Future<bool> resetPasswordWithToken(String newPassword, String recoveryToken) async {
    try {
      state = const AuthState.loading();
      await _authService.updatePasswordWithRecoveryToken(
        newPassword: newPassword,
        recoveryToken: recoveryToken,
      );
      state = const AuthState.unauthenticated(); // usuário não está logado ainda
      return true;
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  // Getters públicos seguros
  Usuario? get currentUser => state.maybeWhen(authenticated: (u) => u, orElse: () => null);
  bool get isAuthenticated => state.maybeWhen(authenticated: (_) => true, orElse: () => false);
  String? get errorMessage => state.maybeWhen(error: (msg) => msg, orElse: () => null);
}
