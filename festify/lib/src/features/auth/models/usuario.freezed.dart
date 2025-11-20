// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usuario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Usuario {

@JsonKey(name: 'nome_razao_social') String? get nomeRazaoSocial;@JsonKey(name: 'email_usuario') String? get emailUsuario;@JsonKey(name: 'cpf_usuario') String? get cpfUsuario;@JsonKey(name: 'permissao_usuario') String? get permissaoUsuario;@JsonKey(name: 'telefone_usuario') String? get telefoneUsuario;@JsonKey(name: 'status_usuario') String? get statusUsuario;@JsonKey(name: 'id_usuario', fromJson: UuidConverter.fromJson, toJson: UuidConverter.toJson) UuidValue get idUsuario;
/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsuarioCopyWith<Usuario> get copyWith => _$UsuarioCopyWithImpl<Usuario>(this as Usuario, _$identity);

  /// Serializes this Usuario to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Usuario&&(identical(other.nomeRazaoSocial, nomeRazaoSocial) || other.nomeRazaoSocial == nomeRazaoSocial)&&(identical(other.emailUsuario, emailUsuario) || other.emailUsuario == emailUsuario)&&(identical(other.cpfUsuario, cpfUsuario) || other.cpfUsuario == cpfUsuario)&&(identical(other.permissaoUsuario, permissaoUsuario) || other.permissaoUsuario == permissaoUsuario)&&(identical(other.telefoneUsuario, telefoneUsuario) || other.telefoneUsuario == telefoneUsuario)&&(identical(other.statusUsuario, statusUsuario) || other.statusUsuario == statusUsuario)&&(identical(other.idUsuario, idUsuario) || other.idUsuario == idUsuario));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomeRazaoSocial,emailUsuario,cpfUsuario,permissaoUsuario,telefoneUsuario,statusUsuario,idUsuario);

@override
String toString() {
  return 'Usuario(nomeRazaoSocial: $nomeRazaoSocial, emailUsuario: $emailUsuario, cpfUsuario: $cpfUsuario, permissaoUsuario: $permissaoUsuario, telefoneUsuario: $telefoneUsuario, statusUsuario: $statusUsuario, idUsuario: $idUsuario)';
}


}

/// @nodoc
abstract mixin class $UsuarioCopyWith<$Res>  {
  factory $UsuarioCopyWith(Usuario value, $Res Function(Usuario) _then) = _$UsuarioCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'nome_razao_social') String? nomeRazaoSocial,@JsonKey(name: 'email_usuario') String? emailUsuario,@JsonKey(name: 'cpf_usuario') String? cpfUsuario,@JsonKey(name: 'permissao_usuario') String? permissaoUsuario,@JsonKey(name: 'telefone_usuario') String? telefoneUsuario,@JsonKey(name: 'status_usuario') String? statusUsuario,@JsonKey(name: 'id_usuario', fromJson: UuidConverter.fromJson, toJson: UuidConverter.toJson) UuidValue idUsuario
});




}
/// @nodoc
class _$UsuarioCopyWithImpl<$Res>
    implements $UsuarioCopyWith<$Res> {
  _$UsuarioCopyWithImpl(this._self, this._then);

  final Usuario _self;
  final $Res Function(Usuario) _then;

/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nomeRazaoSocial = freezed,Object? emailUsuario = freezed,Object? cpfUsuario = freezed,Object? permissaoUsuario = freezed,Object? telefoneUsuario = freezed,Object? statusUsuario = freezed,Object? idUsuario = null,}) {
  return _then(_self.copyWith(
nomeRazaoSocial: freezed == nomeRazaoSocial ? _self.nomeRazaoSocial : nomeRazaoSocial // ignore: cast_nullable_to_non_nullable
as String?,emailUsuario: freezed == emailUsuario ? _self.emailUsuario : emailUsuario // ignore: cast_nullable_to_non_nullable
as String?,cpfUsuario: freezed == cpfUsuario ? _self.cpfUsuario : cpfUsuario // ignore: cast_nullable_to_non_nullable
as String?,permissaoUsuario: freezed == permissaoUsuario ? _self.permissaoUsuario : permissaoUsuario // ignore: cast_nullable_to_non_nullable
as String?,telefoneUsuario: freezed == telefoneUsuario ? _self.telefoneUsuario : telefoneUsuario // ignore: cast_nullable_to_non_nullable
as String?,statusUsuario: freezed == statusUsuario ? _self.statusUsuario : statusUsuario // ignore: cast_nullable_to_non_nullable
as String?,idUsuario: null == idUsuario ? _self.idUsuario : idUsuario // ignore: cast_nullable_to_non_nullable
as UuidValue,
  ));
}

}


/// Adds pattern-matching-related methods to [Usuario].
extension UsuarioPatterns on Usuario {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Usuario value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Usuario() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Usuario value)  $default,){
final _that = this;
switch (_that) {
case _Usuario():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Usuario value)?  $default,){
final _that = this;
switch (_that) {
case _Usuario() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'nome_razao_social')  String? nomeRazaoSocial, @JsonKey(name: 'email_usuario')  String? emailUsuario, @JsonKey(name: 'cpf_usuario')  String? cpfUsuario, @JsonKey(name: 'permissao_usuario')  String? permissaoUsuario, @JsonKey(name: 'telefone_usuario')  String? telefoneUsuario, @JsonKey(name: 'status_usuario')  String? statusUsuario, @JsonKey(name: 'id_usuario', fromJson: UuidConverter.fromJson, toJson: UuidConverter.toJson)  UuidValue idUsuario)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Usuario() when $default != null:
return $default(_that.nomeRazaoSocial,_that.emailUsuario,_that.cpfUsuario,_that.permissaoUsuario,_that.telefoneUsuario,_that.statusUsuario,_that.idUsuario);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'nome_razao_social')  String? nomeRazaoSocial, @JsonKey(name: 'email_usuario')  String? emailUsuario, @JsonKey(name: 'cpf_usuario')  String? cpfUsuario, @JsonKey(name: 'permissao_usuario')  String? permissaoUsuario, @JsonKey(name: 'telefone_usuario')  String? telefoneUsuario, @JsonKey(name: 'status_usuario')  String? statusUsuario, @JsonKey(name: 'id_usuario', fromJson: UuidConverter.fromJson, toJson: UuidConverter.toJson)  UuidValue idUsuario)  $default,) {final _that = this;
switch (_that) {
case _Usuario():
return $default(_that.nomeRazaoSocial,_that.emailUsuario,_that.cpfUsuario,_that.permissaoUsuario,_that.telefoneUsuario,_that.statusUsuario,_that.idUsuario);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'nome_razao_social')  String? nomeRazaoSocial, @JsonKey(name: 'email_usuario')  String? emailUsuario, @JsonKey(name: 'cpf_usuario')  String? cpfUsuario, @JsonKey(name: 'permissao_usuario')  String? permissaoUsuario, @JsonKey(name: 'telefone_usuario')  String? telefoneUsuario, @JsonKey(name: 'status_usuario')  String? statusUsuario, @JsonKey(name: 'id_usuario', fromJson: UuidConverter.fromJson, toJson: UuidConverter.toJson)  UuidValue idUsuario)?  $default,) {final _that = this;
switch (_that) {
case _Usuario() when $default != null:
return $default(_that.nomeRazaoSocial,_that.emailUsuario,_that.cpfUsuario,_that.permissaoUsuario,_that.telefoneUsuario,_that.statusUsuario,_that.idUsuario);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Usuario extends Usuario {
  const _Usuario({@JsonKey(name: 'nome_razao_social') this.nomeRazaoSocial, @JsonKey(name: 'email_usuario') this.emailUsuario, @JsonKey(name: 'cpf_usuario') this.cpfUsuario, @JsonKey(name: 'permissao_usuario') this.permissaoUsuario, @JsonKey(name: 'telefone_usuario') this.telefoneUsuario, @JsonKey(name: 'status_usuario') this.statusUsuario, @JsonKey(name: 'id_usuario', fromJson: UuidConverter.fromJson, toJson: UuidConverter.toJson) required this.idUsuario}): super._();
  factory _Usuario.fromJson(Map<String, dynamic> json) => _$UsuarioFromJson(json);

@override@JsonKey(name: 'nome_razao_social') final  String? nomeRazaoSocial;
@override@JsonKey(name: 'email_usuario') final  String? emailUsuario;
@override@JsonKey(name: 'cpf_usuario') final  String? cpfUsuario;
@override@JsonKey(name: 'permissao_usuario') final  String? permissaoUsuario;
@override@JsonKey(name: 'telefone_usuario') final  String? telefoneUsuario;
@override@JsonKey(name: 'status_usuario') final  String? statusUsuario;
@override@JsonKey(name: 'id_usuario', fromJson: UuidConverter.fromJson, toJson: UuidConverter.toJson) final  UuidValue idUsuario;

/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsuarioCopyWith<_Usuario> get copyWith => __$UsuarioCopyWithImpl<_Usuario>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsuarioToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Usuario&&(identical(other.nomeRazaoSocial, nomeRazaoSocial) || other.nomeRazaoSocial == nomeRazaoSocial)&&(identical(other.emailUsuario, emailUsuario) || other.emailUsuario == emailUsuario)&&(identical(other.cpfUsuario, cpfUsuario) || other.cpfUsuario == cpfUsuario)&&(identical(other.permissaoUsuario, permissaoUsuario) || other.permissaoUsuario == permissaoUsuario)&&(identical(other.telefoneUsuario, telefoneUsuario) || other.telefoneUsuario == telefoneUsuario)&&(identical(other.statusUsuario, statusUsuario) || other.statusUsuario == statusUsuario)&&(identical(other.idUsuario, idUsuario) || other.idUsuario == idUsuario));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nomeRazaoSocial,emailUsuario,cpfUsuario,permissaoUsuario,telefoneUsuario,statusUsuario,idUsuario);

@override
String toString() {
  return 'Usuario(nomeRazaoSocial: $nomeRazaoSocial, emailUsuario: $emailUsuario, cpfUsuario: $cpfUsuario, permissaoUsuario: $permissaoUsuario, telefoneUsuario: $telefoneUsuario, statusUsuario: $statusUsuario, idUsuario: $idUsuario)';
}


}

/// @nodoc
abstract mixin class _$UsuarioCopyWith<$Res> implements $UsuarioCopyWith<$Res> {
  factory _$UsuarioCopyWith(_Usuario value, $Res Function(_Usuario) _then) = __$UsuarioCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'nome_razao_social') String? nomeRazaoSocial,@JsonKey(name: 'email_usuario') String? emailUsuario,@JsonKey(name: 'cpf_usuario') String? cpfUsuario,@JsonKey(name: 'permissao_usuario') String? permissaoUsuario,@JsonKey(name: 'telefone_usuario') String? telefoneUsuario,@JsonKey(name: 'status_usuario') String? statusUsuario,@JsonKey(name: 'id_usuario', fromJson: UuidConverter.fromJson, toJson: UuidConverter.toJson) UuidValue idUsuario
});




}
/// @nodoc
class __$UsuarioCopyWithImpl<$Res>
    implements _$UsuarioCopyWith<$Res> {
  __$UsuarioCopyWithImpl(this._self, this._then);

  final _Usuario _self;
  final $Res Function(_Usuario) _then;

/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nomeRazaoSocial = freezed,Object? emailUsuario = freezed,Object? cpfUsuario = freezed,Object? permissaoUsuario = freezed,Object? telefoneUsuario = freezed,Object? statusUsuario = freezed,Object? idUsuario = null,}) {
  return _then(_Usuario(
nomeRazaoSocial: freezed == nomeRazaoSocial ? _self.nomeRazaoSocial : nomeRazaoSocial // ignore: cast_nullable_to_non_nullable
as String?,emailUsuario: freezed == emailUsuario ? _self.emailUsuario : emailUsuario // ignore: cast_nullable_to_non_nullable
as String?,cpfUsuario: freezed == cpfUsuario ? _self.cpfUsuario : cpfUsuario // ignore: cast_nullable_to_non_nullable
as String?,permissaoUsuario: freezed == permissaoUsuario ? _self.permissaoUsuario : permissaoUsuario // ignore: cast_nullable_to_non_nullable
as String?,telefoneUsuario: freezed == telefoneUsuario ? _self.telefoneUsuario : telefoneUsuario // ignore: cast_nullable_to_non_nullable
as String?,statusUsuario: freezed == statusUsuario ? _self.statusUsuario : statusUsuario // ignore: cast_nullable_to_non_nullable
as String?,idUsuario: null == idUsuario ? _self.idUsuario : idUsuario // ignore: cast_nullable_to_non_nullable
as UuidValue,
  ));
}


}

// dart format on
