import 'package:festify/src/features/core/helpers/uuid_converter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid_value.dart';

part 'usuario.g.dart';
part 'usuario.freezed.dart';

@Freezed()
abstract class Usuario with _$Usuario {
   const factory Usuario({
     @JsonKey(name: 'nome_razao_social') String? nomeRazaoSocial,
     @JsonKey(name: 'email_usuario') String? emailUsuario,
     @JsonKey(name: 'cpf_usuario') String? cpfUsuario,
     @JsonKey(name: 'permissao_usuario') String? permissaoUsuario,
     @JsonKey(name: 'telefone_usuario') String? telefoneUsuario,
     @JsonKey(name: 'status_usuario') String? statusUsuario,
     @JsonKey(
        name: 'id_usuario',
        fromJson: UuidConverter.fromJson,
        toJson: UuidConverter.toJson,
    ) required UuidValue idUsuario
  }) = _Usuario;

  const Usuario._();
  factory Usuario.fromJson(Map<String, dynamic> json) => _$UsuarioFromJson(json);
}

final usuarioProvider = StateProvider<Usuario?>((ref) => null);
