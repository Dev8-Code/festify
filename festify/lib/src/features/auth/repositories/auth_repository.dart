import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository({required SupabaseClient supabase}) : _supabase = supabase;

  /// Faz login com email e senha
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException {
      rethrow;
    }
  }

  /// Faz logout
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException {
      rethrow;
    }
  }

  /// Busca dados do usuário logado na tabela 'usuarios'
  Future<Usuario?> getCurrentUser() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('usuarios')
          .select()
          .eq('id_usuario', userId)
          .maybeSingle();

      if (response == null) return null;

      return Usuario.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Verifica se há uma sessão ativa
  Session? get currentSession => _supabase.auth.currentSession;

  /// Usuário atualmente autenticado
  User? get currentAuthUser => _supabase.auth.currentUser;

  /// Stream de mudanças de autenticação
  Stream<Session?> get authStateChanges =>
      _supabase.auth.onAuthStateChange.map((data) => data.session);

  /// Envia email de recuperação de senha
  Future<void> resetPassword(String email, {String? redirectTo}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: redirectTo,
      );
    } on AuthException {
      rethrow;
    }
  }

  /// Atualiza senha do usuário logado
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException {
      rethrow;
    }
  }

  /// Atualiza senha usando token de recuperação (Web)
  Future<void> updatePasswordWithRecoveryToken({
    required String newPassword,
    required String recoveryToken,
  }) async {
    try {
      // Recupera sessão temporária usando o token
      await _supabase.auth.recoverSession(recoveryToken);

      // Atualiza a senha agora que a sessão está ativa
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException {
      rethrow;
    }
  }

  /// Verifica se o usuário está autenticado
  bool isAuthenticated() {
    return _supabase.auth.currentUser != null &&
        _supabase.auth.currentSession != null;
  }
}
