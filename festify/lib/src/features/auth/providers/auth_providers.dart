import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/providers/database_provider.dart';
import '../repositories/auth_repository.dart';
import '../services/auth_service.dart';

part 'auth_providers.g.dart';

/// Provider do AuthRepository
@riverpod
AuthRepository authRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRepository(supabase: supabase);
}

/// Provider do AuthService
@riverpod
AuthService authService(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthService(repository: repository);
}

/// Provider para controlar visibilidade da senha (usado na UI)
final senhaVisivelProvider = StateProvider<bool>((ref) => false);

/// Provider para controlar estado de loading em telas específicas
final isLoadingProvider = StateProvider<bool>((ref) => false);
