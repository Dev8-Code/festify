import 'package:festify/src/features/core/providers/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_viewmodel.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel{

  @override
  Future<void> build() async {

  }

  Future<void> login(String email, String senha) async {

    state = AsyncLoading();

    try {
      final client = ref.read(supabaseClientProvider);
      final response = await client.auth.signInWithPassword(
        email: email,
        password: senha
      ); 
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
} 