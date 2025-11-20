import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/usuario.dart';

part 'auth_state.freezed.dart';

/// Estados de autenticação da aplicação
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthStateInitial;
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.authenticated(Usuario usuario) =
      AuthStateAuthenticated;
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  const factory AuthState.error(String message) = AuthStateError;
}
