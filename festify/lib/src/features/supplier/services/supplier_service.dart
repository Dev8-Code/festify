import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> cadastrarFornecedor({
  required BuildContext context,
  required String nome,
  required String cnpj,
  required String razao,
  required String email,
  required String telefone,
}) async {
  try {
    await Supabase.instance.client.from('fornecedores').insert({
      'nome_fornecedor': nome,
      'cnpj_fornecedor': cnpj,
      'razao_social_fornecedor': razao,
      'email_fornecedor': email,
      'telefone_fornecedor': telefone,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fornecedor cadastrado com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Erro ao cadastrar: $e')));
  }
}

Future<void> deleteFornecedor({
  required BuildContext context,
  required int idFornecedor,
}) async {
  try {
    await Supabase.instance.client
        .from('fornecedores')
        .delete()
        .eq('id_fornecedor', idFornecedor);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fornecedor excluído com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Erro ao excluir fornecedor: $e')));
  }
}
