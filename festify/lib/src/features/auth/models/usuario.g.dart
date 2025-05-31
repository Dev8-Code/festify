// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Usuario _$UsuarioFromJson(Map<String, dynamic> json) => _Usuario(
  nomeRazaoSocial: json['nome_razao_social'] as String?,
  emailUsuario: json['email_usuario'] as String?,
  cpfUsuario: json['cpf_usuario'] as String?,
  permissaoUsuario: json['permissao_usuario'] as String?,
  telefoneUsuario: json['telefone_usuario'] as String?,
  statusUsuario: json['status_usuario'] as String?,
  idUsuario: UuidConverter.fromJson(json['id_usuario'] as String),
);

Map<String, dynamic> _$UsuarioToJson(_Usuario instance) => <String, dynamic>{
  'nome_razao_social': instance.nomeRazaoSocial,
  'email_usuario': instance.emailUsuario,
  'cpf_usuario': instance.cpfUsuario,
  'permissao_usuario': instance.permissaoUsuario,
  'telefone_usuario': instance.telefoneUsuario,
  'status_usuario': instance.statusUsuario,
  'id_usuario': UuidConverter.toJson(instance.idUsuario),
};
