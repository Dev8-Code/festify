import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> registerOperator({
  required String nome,
  required String cpf,
  required String email,
  required String telefone,
  required String senha,

}) async {

  try {
    await Supabase.instance.client.from('usuarios').insert({
      'nome_razao_social': nome,
      'cpf_usuario': cpf,
      'email_usuario': email,
      'telefone_usuario': telefone,
      'senha_usuario': senha,
      'permissao_usuario': 'operador',
      'status_usuario': 'ativo',
    });

    return 'Operador cadastrado com sucesso!';
  } catch (e) {
    return 'Erro ao cadastrar: $e';
  }
}