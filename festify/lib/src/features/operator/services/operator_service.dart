import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> registerOperator({
  required BuildContext context
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Operador cadastrado com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao cadastrar: $e')),
    );
  }
}