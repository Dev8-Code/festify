import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContractService {
  static final _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> buscarEventosComClientes() async {
    try {
      final response = await _supabase
          .from('eventos')
          .select('''
            id_evento,
            tipo_evento,
            data_evento,
            status_evento,
            nome_beneficiario_pagador_evento,
            clientes (
              nome_razao_social
            )
          ''')
          .order('id_evento', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  // Buscar evento específico por ID com dados do cliente
  static Future<Map<String, dynamic>?> buscarEventoPorIdComCliente(
    int idEvento,
  ) async {
    try {
      final response =
          await _supabase
              .from('eventos')
              .select('''
            id_evento,
            tipo_evento,
            data_evento,
            status_evento,
            nome_beneficiario_pagador_evento,
            clientes (
              nome_razao_social
            )
          ''')
              .eq('id_evento', idEvento)
              .single();

      return response;
    } catch (e) {
      return null;
    }
  }

  // Excluir evento
  static Future<String> excluirEvento({
    required BuildContext context,
    required int idEvento,
  }) async {
    try {
      await _supabase.from('eventos').delete().eq('id_evento', idEvento);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento excluído com sucesso!')),
      );

      return 'success';
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir evento: $e')));
      return 'error';
    }
  }

  // Formatar data para exibição
  static String formatarData(String data) {
    try {
      final DateTime dateTime = DateTime.parse(data);
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    } catch (e) {
      return data;
    }
  }

  // Traduzir status para português
  static String traduzirStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pendente':
        return 'Pendente de geração';
      case 'gerado':
        return 'Gerado';
      case 'assinado':
        return 'Assinado';
      case 'pendente_assinatura':
        return 'Pendente de Assinatura';
      default:
        return status;
    }
  }

  static Future<int?> cadastrarContrato({
    required int idEvento,
    required int parcelas,
    required String dataVencimento,
    required double valorContrato,
    required double valorPago,
    String? tituloContrato,
  }) async {
    try {
      final titulo = tituloContrato ?? 'Contrato do Evento $idEvento';

      final response =
          await _supabase
              .from('contratos')
              .insert({
                'parcela_contrato': parcelas,
                'data_vencimento_contrato': dataVencimento,
                'titulo_contrato': titulo,
                'status_contrato': 'pendente',
                'envio_assinatura_contrato': false,
                'assinatura_contrato': false,
                'caminho_doc_contrato': '',
                'valor_contrato': valorContrato,
                'valor_pago_contrato': valorPago,
                'id_evento': idEvento,
              })
              .select('id_contrato')
              .single();

      return response['id_contrato'] as int?;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> buscarContratosPorEvento(
    int idEvento,
  ) async {
    try {
      final response = await _supabase
          .from('contratos')
          .select()
          .eq('id_evento', idEvento)
          .order('id_contrato', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar contratos: $e');
      return [];
    }
  }

  static Future<bool> atualizarContrato({
    required int idContrato,
    required Map<String, dynamic> dados,
  }) async {
    try {
      await _supabase
          .from('contratos')
          .update(dados)
          .eq('id_contrato', idContrato);

      return true;
    } catch (e) {
      print('Erro ao atualizar contrato: $e');
      return false;
    }
  }
}
