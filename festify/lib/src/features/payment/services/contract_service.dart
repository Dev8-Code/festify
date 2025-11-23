import 'package:supabase_flutter/supabase_flutter.dart';

class ContractService {
  static final _supabase = Supabase.instance.client;

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
      return false;
    }
  }
}
