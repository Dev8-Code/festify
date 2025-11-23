import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> registerOperator({
  required BuildContext context,
  required String nome,
  required String cpf,
  required String email,
  required String telefone,
  required String senha,
}) async {
  try {
    final supabase = Supabase.instance.client;

    final AuthResponse authResponse = await supabase.auth.signUp(
      email: email,
      password: senha,
    );

    if (authResponse.user == null) {
      throw Exception('Falha ao criar usuário na autenticação');
    }

    await supabase.from('usuarios').insert({
      'id_usuario': authResponse.user!.id,
      'nome_razao_social': nome,
      'cpf_usuario': cpf,
      'email_usuario': email,
      'telefone_usuario': telefone,
      'permissao_usuario': 'operador',
      'status_usuario': 'ativo',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Operador cadastrado com sucesso!')),
    );

    return 'success';
  } on AuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro de autenticação: ${e.message}')),
    );
    return 'error';
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Erro ao cadastrar: $e')));
    return 'error';
  }
}

Future<String> deleteOperator({
  required BuildContext context,
  required String idOperador,
}) async {
  try {
    final supabase = Supabase.instance.client;
    await supabase.from('usuarios').delete().eq('id_usuario', idOperador);
    try {
      await supabase.auth.admin.deleteUser(idOperador);
    } catch (e) {
      await supabase
          .from('usuarios')
          .update({'status_usuario': 'inativo'})
          .eq('id_usuario', idOperador);

      print(
        'Não foi possível deletar do auth.users, usuário marcado como inativo',
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Operador excluído com sucesso!')),
    );

    return 'success';
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Erro ao excluir operador: $e')));
    return 'error';
  }
}
