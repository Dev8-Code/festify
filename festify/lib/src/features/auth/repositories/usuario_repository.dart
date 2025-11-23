import 'package:festify/src/features/auth/models/usuario.dart';
import 'package:festify/src/features/core/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'usuario_repository.g.dart';

class UsuarioRepository {
  final SupabaseClient supabase;

  UsuarioRepository({required this.supabase});

  FutureOr<Usuario?> usuarioLogado() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      return null;
    }

    final usuarioResponse = await supabase
      .from('Usuario')
      .select()
      .eq('id_usuario', userId)
      .limit(1)
      .single();
      
    return Usuario.fromJson(usuarioResponse);
  }
}

@riverpod
UsuarioRepository usuarioRepository(Ref ref) {
  return UsuarioRepository(supabase: ref.watch(supabaseClientProvider));
}

@Riverpod(keepAlive: true)
FutureOr<Usuario?> usuario(Ref ref) {
  return ref.watch(usuarioRepositoryProvider).usuarioLogado();
}

