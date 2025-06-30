import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastraClienteService {
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
    required DateTime dataNascimento,
  }) async {
    try {
      final enderecoCompleto =
          '$logradouro, Nº $numero, Bairro $bairro, $cidade - $estado, CEP: $cep';

      await Supabase.instance.client.from('clientes').insert({
        'responsavel_cliente': nome,
        'cpf_cliente': cpf,
        'rg_cliente': rg,
        'email_cliente': email,
        'tel_cliente': telefone,
        'endereco_cliente': enderecoCompleto,
        'data_nasc_cliente':
            dataNascimento.toIso8601String().split(
              'T',
            )[0], // Format: YYYY-MM-DD
        'tipo_cliente': 'fisica',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente Pessoa Física cadastrado com sucesso!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao cadastrar: $e')));
    }
  }

  Future<void> cadastrarJuridica({
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
        'tel_cliente': telefone,
        'tipo_cliente': 'juridica',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente Pessoa Jurídica cadastrado com sucesso!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao cadastrar: $e')));
    }
  }
}
