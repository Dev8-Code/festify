import 'package:festify/src/features/core/providers/database_provider.dart';  
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_viewmodel.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {

  @override
  Future<void> build() async {

  }

  Future<bool> login(String email, String senha) async {
    state = AsyncLoading();

    try {
      final supabase = ref.read(supabaseClientProvider);
      await supabase.auth.signOut(); //todo: remover essa linha, manter apenas para testes

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: senha
      ); 

      if (response.session == null) {
        state = AsyncError("Usuário ou senha inválidos", StackTrace.current);
        return false;
      }

      return true;

    } catch (e, st) {
      if (e is AuthApiException) {
        state = AsyncError("Usuário ou senha inválidos", st);
      }
      state = AsyncError("Não foi possível realizar o login", st);
      return false;
    }
  }
}