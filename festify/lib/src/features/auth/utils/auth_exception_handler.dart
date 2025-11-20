import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Classe utilitária para tratamento de exceções de autenticação
/// Mapeia erros do Supabase para mensagens amigáveis em português
class AuthExceptionHandler {
  /// Trata exceções de autenticação e retorna mensagem localizada
  static String handleAuthException(AuthException e) {
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

      case '500':
      case '502':
      case '503':
        return 'Serviço indisponível. Tente novamente mais tarde.';

      default:
        // Se nenhum código corresponder, trata pela mensagem
        if (e.message.contains('Invalid login credentials')) {
          return 'Email ou senha inválidos.';
        } else if (e.message.contains('Email not confirmed')) {
          return 'Email não confirmado. Verifique seu email.';
        } else if (e.message.contains('User not found')) {
          return 'Usuário não encontrado.';
        } else if (e.message.contains('Weak password')) {
          return 'Senha muito fraca. Use uma senha mais forte (mínimo 6 caracteres).';
        } else if (e.message.contains('already registered')) {
          return 'Este email já está registrado.';
        } else if (e.message.contains('Network error')) {
          return 'Erro de conexão. Verifique sua internet.';
        }
        return 'Erro de autenticação: ${e.message}';
    }
  }

  /// Trata exceções genéricas e retorna mensagem localizada
  static String handleException(Object e) {
    if (e is AuthException) {
      return handleAuthException(e);
    } else if (e is SocketException) {
      return 'Erro de conexão. Verifique sua internet.';
    } else if (e.toString().contains('Network')) {
      return 'Erro de rede. Verifique sua conexão com a internet.';
    } else {
      return 'Erro: ${e.toString()}';
    }
  }
}
