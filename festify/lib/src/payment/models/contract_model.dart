class Contrato {
  final int idEvento;
  final double valorContrato;
  final double valorPago;
  final int parcelas;
  final String dataVencimento;

  Contrato({
    required this.idEvento,
    required this.valorContrato,
    required this.valorPago,
    required this.parcelas,
    required this.dataVencimento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_evento': idEvento,
      'valor_contrato': valorContrato,
      'valor_pago_contrato': valorPago,
      'parcela_contrato': parcelas,
      'data_vencimento_contrato': dataVencimento,
      'status_contrato': 'pendente',
      'envio_assinatura_contrato': false,
      'assinatura_contrato': false,
      'caminho_doc_contrato': null,
    };
  }
}
