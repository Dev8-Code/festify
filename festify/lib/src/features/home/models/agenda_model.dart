class AgendaModel {
  final int? idAgenda;
  final DateTime dataBloqueio;
  final String? motivo;
  final String tipo;
  final int idEvento;

  AgendaModel({
    this.idAgenda,
    required this.dataBloqueio,
    this.motivo,
    required this.tipo,
    required this.idEvento,
  });

  factory AgendaModel.fromMap(Map<String, dynamic> map) {
    return AgendaModel(
      idAgenda: map['id_agenda'],
      dataBloqueio: DateTime.parse(map['data_bloq_agenda']),
      motivo: map['motivo_bloq_agenda'],
      tipo: map['tipo_bloq_agenda'],
      idEvento: map['id_evento'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data_bloq_agenda': dataBloqueio.toIso8601String(),
      'motivo_bloq_agenda': motivo,
      'tipo_bloq_agenda': tipo,
      'id_evento': idEvento,
    };
  }
}
