import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Handler para processar links de redefinição de senha
/// Captura o token do link enviado por email
class ResetPasswordHandler {
  static final _instance = ResetPasswordHandler._internal();

  factory ResetPasswordHandler() {
    return _instance;
  }

  ResetPasswordHandler._internal();

  /// Inicializa o handler para processar redirecionamento do Supabase Auth
  /// O Supabase automaticamente lida com o token quando app abre via deep link
  void initialize() {
    // Supabase já configura automaticamente a sessão quando há token
    // Este é apenas um utility para validar e gerenciar o processo
    debugPrint('ResetPasswordHandler inicializado');
  }

  /// Verifica se há uma sessão válida criada pelo link de recuperação
  static bool hasValidRecoverySession() {
    try {
      final supabase = Supabase.instance.client;
      final session = supabase.auth.currentSession;

      // Se há sessão, o link foi processado com sucesso
      return session != null;
    } catch (e) {
      debugPrint('Erro ao verificar sessão: $e');
      return false;
    }
  }

  /// Processa o token do link de recuperação
  /// Retorna true se o token é válido
  static bool validateRecoveryToken(String? token) {
    if (token == null || token.isEmpty) return false;
    // Token Supabase geralmente tem 40+ caracteres
    return token.length >= 20;
  }

  /// Extrai mensagem de erro se o link foi inválido
  /// Formato esperado: ?error=xxx&error_description=yyy
  static String? getErrorMessage(Uri uri) {
    final error = uri.queryParameters['error'];
    final errorDescription = uri.queryParameters['error_description'];

    if (error != null) {
      if (error == 'access_denied') {
        return 'Acesso negado. O link pode ter expirado.';
      }
      if (error == 'invalid_request') {
        return 'Requisição inválida. Por favor, tente novamente.';
      }
      return errorDescription ?? error;
    }
    return null;
  }

  /// Log para debug
  static void debugLogToken(String? token) {
    if (token != null && token.isNotEmpty) {
      final length = token.length;
      final preview = token.substring(0, 10) + '...';
      debugPrint('Token encontrado: $preview (comprimento: $length)');
    }
  }
}
