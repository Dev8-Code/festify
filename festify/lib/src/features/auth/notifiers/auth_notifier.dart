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

  @override
  AuthState build() {
    _authService = ref.watch(authServiceProvider);
    _checkInitialSession();
    // Escuta mudanças de autenticação do Supabase
    _setupAuthStateListener();
    return const AuthState.initial();
  }

  /// Configura um listener para mudanças de autenticação
  /// Útil para sincronizar estado quando sessão expira
  void _setupAuthStateListener() {
    _authService.authStateChanges.listen((authState) {
      // Se a sessão foi destruída (logout ou expiração)
      if (authState.session == null) {
        state = const AuthState.unauthenticated();
      } else {
        // Se nova sessão foi criada, verifica dados do usuário
        _checkInitialSession();
      }
    });
  }

  /// Verifica se há uma sessão ativa ao inicializar o app
  /// Restaura o usuário se houver sessão persistida
  Future<void> _checkInitialSession() async {
    state = const AuthState.loading();

    try {
      final usuario = await _authService.checkSession();

      if (usuario != null) {
        state = AuthState.authenticated(usuario);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  /// Realiza login com email e senha
  /// Retorna true se o login foi bem-sucedido, false caso contrário
  Future<bool> login({required String email, required String password}) async {
    state = const AuthState.loading();

    try {
      final usuario = await _authService.login(
        email: email,
        password: password,
      );

      state = AuthState.authenticated(usuario);
      return true;
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  /// Realiza logout e limpa a sessão
  /// Também redireciona para a tela de login
  Future<void> logout() async {
    state = const AuthState.loading();

    try {
      await _authService.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error('Erro ao fazer logout: ${e.toString()}');
      // Mesmo em caso de erro, força o estado para unauthenticated
      state = const AuthState.unauthenticated();
    }
  }

  /// Recupera senha enviando email de recuperação
  /// Retorna true se o email foi enviado com sucesso
  Future<bool> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  /// Atualiza a senha do usuário atualmente autenticado
  /// Retorna true se a senha foi atualizada com sucesso
  Future<bool> updatePassword(String newPassword) async {
    try {
      await _authService.updatePassword(newPassword);
      return true;
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  /// Obtém o usuário atualmente autenticado
  /// Retorna null se não estiver autenticado
  Usuario? get currentUser {
    return state.maybeWhen(
      authenticated: (usuario) => usuario,
      orElse: () => null,
    );
  }

  /// Verifica se o usuário está autenticado
  bool get isAuthenticated {
    return state.maybeWhen(authenticated: (_) => true, orElse: () => false);
  }

  /// Obtém a mensagem de erro se houver
  String? get errorMessage {
    return state.maybeWhen(error: (message) => message, orElse: () => null);
  }
}
