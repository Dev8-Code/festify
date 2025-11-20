import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository({required SupabaseClient supabase}) : _supabase = supabase;

  /// Faz login com email e senha
  /// Retorna a resposta de autenticação do Supabase
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

  /// Faz logout e limpa a sessão
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException {
      rethrow;
    }
  }

  /// Busca dados do usuário logado na tabela 'usuarios'
  /// Retorna null se o usuário não estiver autenticado ou não existir na tabela
  Future<Usuario?> getCurrentUser() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response =
          await _supabase
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

  /// Obtém o usuário atualmente autenticado do Auth
  User? get currentAuthUser => _supabase.auth.currentUser;

  /// Stream de mudanças de autenticação
  /// Emite eventos quando o usuário faz login, logout ou a sessão expira
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Recuperação de senha
  /// Envia um email de recuperação para o usuário
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException {
      rethrow;
    }
  }

  /// Atualiza a senha do usuário atualmente autenticado
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      return await _supabase.auth.updateUser(
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

  /// Cria um novo usuário na tabela 'usuarios' após ser criado no Auth
  /// Nota: O trigger do Supabase cria o usuário no auth.users automaticamente
  Future<void> createUserInDatabase({
    required String idUsuario,
    required String emailUsuario,
    required String nomeRazaoSocial,
    String? cpfUsuario,
    String? telefoneUsuario,
  }) async {
    try {
      await _supabase.from('usuarios').insert({
        'id_usuario': idUsuario,
        'email_usuario': emailUsuario,
        'nome_razao_social': nomeRazaoSocial,
        'cpf_usuario': cpfUsuario,
        'telefone_usuario': telefoneUsuario,
        'status_usuario': 'ativo',
        'permissao_usuario': 'cliente', // padrão
      });
    } catch (e) {
      rethrow;
    }
  }
}
