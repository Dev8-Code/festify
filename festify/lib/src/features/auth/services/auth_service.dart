import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario.dart';
import '../repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository;

  AuthService({required AuthRepository repository}) : _repository = repository;

  /// Realiza login com email e senha
  /// Lança exceção com mensagem localizada em caso de erro
  Future<Usuario> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _repository.signIn(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw Exception('Sessão não criada. Verifique suas credenciais.');
      }

      // Busca dados do usuário na tabela usuarios
      final usuario = await _repository.getCurrentUser();

      if (usuario == null) {
        throw Exception('Usuário não encontrado na base de dados.');
      }

      // Verifica se o usuário está ativo
      if (usuario.statusUsuario?.toLowerCase() != 'ativo') {
        await _repository.signOut();
        throw Exception('Usuário inativo. Entre em contato com o suporte.');
      }

      return usuario;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Realiza logout e limpa a sessão
  Future<void> logout() async {
    try {
      await _repository.signOut();
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Verifica se há uma sessão ativa e retorna o usuário
  /// Retorna null se não houver sessão ativa
  Future<Usuario?> checkSession() async {
    try {
      final session = _repository.currentSession;

      // Se não há sessão, retorna null
      if (session == null) return null;

      // Se há sessão, busca os dados do usuário
      return await _repository.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  /// Verifica se o usuário está autenticado
  bool isAuthenticated() {
    return _repository.isAuthenticated();
  }

  /// Obtém o usuário atual autenticado
  /// Retorna null se não houver usuário autenticado
  Future<Usuario?> getCurrentUser() async {
    try {
      return await _repository.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  /// Recuperação de senha
  /// Envia um email de recuperação para o endereço informado
  Future<void> resetPassword(String email) async {
    try {
      await _repository.resetPassword(email);
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Atualiza a senha do usuário atualmente autenticado
  Future<void> updatePassword(String newPassword) async {
    try {
      await _repository.updatePassword(newPassword);
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Stream de mudanças de autenticação
  /// Emite eventos quando o usuário faz login, logout ou a sessão expira
  Stream<AuthState> get authStateChanges => _repository.authStateChanges;

  /// Tratamento de exceções do Supabase Auth com mensagens em português
  /// Mapeia códigos de erro do Supabase para mensagens amigáveis
  String _handleAuthException(AuthException e) {
    // Verifica primeiro pelo código de status
    switch (e.statusCode) {
      case '400':
        // Verifica se é erro de email não confirmado ou credenciais inválidas
        if (e.message.contains('Email not confirmed')) {
          return 'Email não confirmado. Verifique seu email para ativar a conta.';
        } else if (e.message.contains('Invalid login credentials')) {
          return 'Email ou senha inválidos.';
        }
        return 'Requisição inválida. Tente novamente.';

      case '401':
        return 'Não autorizado. Verifique suas credenciais.';

      case '422':
        return 'Email não confirmado. Verifique seu email.';

      case '429':
        return 'Muitas tentativas de login. Tente novamente em alguns minutos.';

      default:
        // Se nenhum código corresponder, trata pela mensagem
        if (e.message.contains('Invalid login credentials')) {
          return 'Email ou senha inválidos.';
        } else if (e.message.contains('Email not confirmed')) {
          return 'Email não confirmado. Verifique seu email.';
        } else if (e.message.contains('User not found')) {
          return 'Usuário não encontrado.';
        } else if (e.message.contains('Weak password')) {
          return 'Senha muito fraca. Use uma senha mais forte.';
        }
        return 'Erro de autenticação: ${e.message}';
    }
  }
}
