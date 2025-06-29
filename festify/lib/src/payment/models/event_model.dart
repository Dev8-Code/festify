class Evento {
  final int? idEvento;
  final String beneficiario;
  final String tipoEvento;
  final String dataEvento;
  final String? horaEvento;
  final int diasMontagem;
  final int diasDesmontagem;
  final String statusEvento;
  final int idCliente;
  final int idLocal;

  Evento({
    this.idEvento,
    required this.beneficiario,
    required this.tipoEvento,
    required this.dataEvento,
    required this.horaEvento,
    required this.diasMontagem,
    required this.diasDesmontagem,
    this.statusEvento = 'pendente',
    required this.idCliente,
    this.idLocal = 1,
  });

  Map<String, dynamic> toMap() => {
    'beneficiario_e_pagador_evento': beneficiario,
    'tipo_evento': tipoEvento,
    'data_evento': dataEvento,
    'hora_evento': horaEvento,
    'qtd_dias_montagem_evento': diasMontagem,
    'qtd_dias_desmontagem_evento': diasDesmontagem,
    'status_evento': statusEvento,
    'id_cliente': idCliente,
    'id_local': idLocal,
  };

  factory Evento.fromMap(Map<String, dynamic> map) => Evento(
    idEvento: map['id_evento'],
    beneficiario: map['beneficiario_e_pagador_evento'],
    tipoEvento: map['tipo_evento'],
    dataEvento: map['data_evento'],
    horaEvento: map['hora_evento'],
    diasMontagem: map['qtd_dias_montagem_evento'],
    diasDesmontagem: map['qtd_dias_desmontagem_evento'],
    statusEvento: map['status_evento'],
    idCliente: map['id_cliente'],
    idLocal: map['id_local'],
  );

  @override
  String toString() {
    return 'Evento(idEvento: $idEvento, beneficiario: $beneficiario, tipoEvento: $tipoEvento, dataEvento: $dataEvento, diasMontagem: $diasMontagem, diasDesmontagem: $diasDesmontagem, statusEvento: $statusEvento, idCliente: $idCliente, idLocal: $idLocal)';
  }
}
