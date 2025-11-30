import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario.dart';
import '../repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository;

  AuthService({required AuthRepository repository}) : _repository = repository;

  /// Login
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

      final usuario = await _repository.getCurrentUser();
      if (usuario == null) {
        await _repository.signOut();
        throw 'Usuário não encontrado na base de dados.';
      }

      if (usuario.statusUsuario?.toLowerCase() != 'ativo') {
        await _repository.signOut();
        throw 'Usuário inativo. Entre em contato com o suporte.';
      }

      return usuario;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } on String {
      rethrow;
    } catch (e) {
      throw 'Erro inesperado: ${e.toString()}';
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _repository.signOut();
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Erro ao fazer logout: ${e.toString()}';
    }
  }

  /// Verifica sessão ativa
  Future<Usuario?> checkSession() async {
    try {
      final session = _repository.currentSession;
      if (session == null) return null;
      return await _repository.getCurrentUser();
    } catch (_) {
      return null;
    }
  }

  /// Reset de senha (envia email)
  Future<void> resetPassword(String email, {String? redirectTo}) async {
    try {
      if (email.isEmpty || !email.contains('@')) {
        throw 'Email inválido';
      }
      await _repository.resetPassword(email, redirectTo: redirectTo);
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Erro ao enviar email de recuperação: ${e.toString()}';
    }
  }

  /// Atualiza senha usando token de recuperação (sem sessão ativa)
  Future<void> updatePasswordWithRecoveryToken({
    required String newPassword,
    required String recoveryToken,
  }) async {
    if (newPassword.isEmpty) throw 'Senha não pode estar vazia';
    if (newPassword.length < 6) throw 'Senha deve ter no mínimo 6 caracteres';

    try {
      await _repository.updatePasswordWithRecoveryToken(
        newPassword: newPassword,
        recoveryToken: recoveryToken,
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Erro ao atualizar senha: ${e.toString()}';
    }
  }

  /// Stream de mudanças de autenticação
  Stream<Session?> get authStateChanges => _repository.authStateChanges;

  /// Tratamento de exceções do Supabase Auth
  String _handleAuthException(AuthException e) {
    final message = e.message.toLowerCase();
    if (message.contains('invalid login credentials') ||
        message.contains('invalid email or password')) {
      return 'Email ou senha inválidos.';
    }
    if (message.contains('email not confirmed')) {
      return 'Email não confirmado. Verifique seu email para ativar a conta.';
    }
    if (message.contains('user not found')) return 'Usuário não encontrado.';
    if (message.contains('weak password')) {
      return 'Senha muito fraca. Use uma senha mais forte (mínimo 6 caracteres).';
    }
    if (message.contains('invalid token') || message.contains('token expired')) {
      return 'Token de recuperação inválido ou expirado.';
    }
    if (message.contains('session does not exist')) {
      return 'Sessão expirada. Faça login novamente.';
    }
    if (message.contains('network') || message.contains('connection')) {
      return 'Erro de conexão. Verifique sua internet.';
    }
    return 'Erro de autenticação: ${e.message}';
  }
}
