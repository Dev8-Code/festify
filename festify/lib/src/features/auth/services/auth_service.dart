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
        throw 'Sessão não criada. Verifique suas credenciais.';
      }

      // Busca dados do usuário na tabela usuarios
      final usuario = await _repository.getCurrentUser();

      if (usuario == null) {
        await _repository.signOut();
        throw 'Usuário não encontrado na base de dados.';
      }

      // Verifica se o usuário está ativo
      if (usuario.statusUsuario?.toLowerCase() != 'ativo') {
        await _repository.signOut();
        throw 'Usuário inativo. Entre em contato com o suporte.';
      }

      return usuario;
    } on AuthException catch (e) {
      // Propaga a mensagem amigável tratada
      throw _handleAuthException(e);
    } on String {
      // Re-lança strings (mensagens customizadas)
      rethrow;
    } catch (e) {
      // Outros erros
      throw 'Erro inesperado: ${e.toString()}';
    }
  }

  /// Realiza logout e limpa a sessão
  Future<void> logout() async {
    try {
      await _repository.signOut();
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Erro ao fazer logout: ${e.toString()}';
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
  /// Valida se o email tem formato válido
  Future<void> resetPassword(String email) async {
    try {
      // Validação básica de email
      if (email.isEmpty || !email.contains('@')) {
        throw 'Email inválido';
      }

      await _repository.resetPassword(email);
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();

      // Tratamentos específicos de erro
      if (errorMsg.contains('user not found') ||
          errorMsg.contains('no user found')) {
        throw 'E-mail não cadastrado na plataforma.';
      }
      if (errorMsg.contains('invalid email')) {
        throw 'Formato de e-mail inválido.';
      }
      if (errorMsg.contains('network') || errorMsg.contains('connection')) {
        throw 'Erro de conexão. Verifique sua internet e tente novamente.';
      }

      throw 'Erro ao enviar email de recuperação: ${e.toString()}';
    }
  }

  /// Atualiza a senha do usuário atualmente autenticado
  /// Requer que o usuário tenha uma sessão válida (via link de recuperação)
  Future<void> updatePassword(String newPassword) async {
    try {
      // Validações de segurança
      if (newPassword.isEmpty) {
        throw 'Senha não pode estar vazia';
      }

      if (newPassword.length < 6) {
        throw 'Senha deve ter no mínimo 6 caracteres';
      }

      await _repository.updatePassword(newPassword);
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();

      // Tratamentos específicos para atualização de senha
      if (errorMsg.contains('no session') ||
          errorMsg.contains('session does not exist') ||
          errorMsg.contains('invalid token')) {
        throw 'Sessão expirada. Por favor, clique no link de recuperação novamente.';
      }
      if (errorMsg.contains('weak password')) {
        throw 'Senha muito fraca. Use uma senha mais forte com letras, números e caracteres especiais.';
      }
      if (errorMsg.contains('network') || errorMsg.contains('connection')) {
        throw 'Erro de conexão. Verifique sua internet e tente novamente.';
      }

      throw 'Erro ao atualizar senha: ${e.toString()}';
    }
  }

  /// Stream de mudanças de autenticação
  /// Emite eventos quando o usuário faz login, logout ou a sessão expira
  Stream<AuthState> get authStateChanges => _repository.authStateChanges;

  /// Tratamento de exceções do Supabase Auth com mensagens em português
  /// Mapeia códigos de erro do Supabase para mensagens amigáveis
  String _handleAuthException(AuthException e) {
    // Primeiro verifica mensagens específicas no corpo do erro
    final message = e.message.toLowerCase();

    if (message.contains('invalid login credentials') ||
        message.contains('invalid email or password')) {
      return 'Email ou senha inválidos.';
    }

    if (message.contains('email not confirmed')) {
      return 'Email não confirmado. Verifique seu email para ativar a conta.';
    }

    if (message.contains('user not found') || message.contains('no user')) {
      return 'Usuário não encontrado.';
    }

    if (message.contains('weak password')) {
      return 'Senha muito fraca. Use uma senha mais forte (mínimo 6 caracteres).';
    }

    if (message.contains('already registered') ||
        message.contains('already exists')) {
      return 'Este email já está registrado.';
    }

    if (message.contains('invalid token') ||
        message.contains('token expired')) {
      return 'Token de recuperação inválido ou expirado.';
    }

    if (message.contains('session does not exist')) {
      return 'Sessão expirada. Por favor, faça login novamente.';
    }

    if (message.contains('network') || message.contains('connection')) {
      return 'Erro de conexão. Verifique sua internet.';
    }

    if (message.contains('rate limit')) {
      return 'Muitas tentativas. Aguarde alguns minutos e tente novamente.';
    }

    // Depois verifica pelo código de status
    if (e.statusCode != null) {
      switch (e.statusCode) {
        case '400':
          return 'Requisição inválida. Verifique os dados informados.';
        case '401':
          return 'Não autorizado. Verifique suas credenciais.';
        case '422':
          return 'Email não confirmado. Verifique seu email.';
        case '429':
          return 'Muitas tentativas. Tente novamente em alguns minutos.';
        case '500':
        case '502':
        case '503':
          return 'Serviço indisponível. Tente novamente mais tarde.';
      }
    }

    // Mensagem padrão se nenhuma condição foi atendida
    return 'Erro de autenticação: ${e.message}';
  }
}
