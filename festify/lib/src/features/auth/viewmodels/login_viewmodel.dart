import 'package:festify/src/features/auth/notifiers/auth_notifier.dart';
import 'package:festify/src/features/auth/utils/auth_exception_handler.dart';
import 'package:festify/src/features/auth/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_viewmodel.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  Future<void> build() async {
    // O estado inicial é AsyncData(null), representando sucesso sem dado.
  }

  Future<bool> login(String email, String senha) async {
    state = const AsyncLoading();

    final authService = ref.read(authServiceProvider);

    try {
      // Usa o AuthService.login() que já faz toda a validação
      // Isso garante que o usuário existe na tabela usuarios
      await authService.login(email: email, password: senha);

      // Após login bem-sucedido, atualiza o estado global de autenticação
      // isso sincroniza com o AuthNotifier
      ref
          .read(authNotifierProvider.notifier)
          .login(email: email, password: senha);

      state = const AsyncData(null);
      return true;
    } on AuthException catch (e, st) {
      final errorMessage = AuthExceptionHandler.handleAuthException(e);
      state = AsyncError(errorMessage, st);
      return false;
    } catch (e, st) {
      final errorMessage = AuthExceptionHandler.handleException(e);
      state = AsyncError(errorMessage, st);
      return false;
    }
  }
}
