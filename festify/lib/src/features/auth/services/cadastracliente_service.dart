import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> cadastrarFisica({
  required BuildContext context,
  required String nome,
  required String cpf,
  required String rg,
  required String email,
  required String telefone,
  required String cep,
  required String numero,
  required String logradouro,
  required String bairro,
  required String cidade,
  required String estado,
}) async {
  try {
    final enderecoCompleto =
        '$logradouro, Nº $numero, Bairro $bairro, $cidade - $estado, CEP: $cep';

    await Supabase.instance.client.from('clientes').insert({
      'nome_razao_social': nome,
      'cpf_clietne': cpf,
      'rg_cliente': rg
      'email_cliente': email,
      'telefone_cliente': telefone,
      'endereco_cliente': enderecoCompleto,  
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cliente Pessoa Física cadastrado com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao cadastrar: \$e')),
    );
  }
}
Future<void> cadastraJuridica({
  required BuildContext context,
  required String razaoSocial,
  required String cnpj,
  required String responsavel,
  required String email,
  required String telefone,
}) async {
  try {
    await Supabase.instance.client.from('clientes').insert({
      'nome_razao_social': razaoSocial,
      'cnpj_cliente': cnpj,
      'responsavel_cliente': responsavel,
      'email_cliente': email,
      'telefone_cliente': telefone,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cliente Pessoa Jurídica cadastrado com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao cadastrar: $e')),
    );
  }
}
