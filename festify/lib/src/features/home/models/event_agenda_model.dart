class Event {
  final int id;
  final String? beneficiaryAndPayer;
  final String? eventType;
  final DateTime eventDate;
  final int? setupDays;
  final int? teardownDays;
  final String? eventStatus;
  final int clientId;
  final int locationId;
  final String? eventTime;
  final String? beneficiaryPayerName;
  final String? eventAddress; // From 'locais' table
  final String? clientName; // From 'clientes' table

  Event({
    required this.id,
    this.beneficiaryAndPayer,
    this.eventType,
    required this.eventDate,
    this.setupDays,
    this.teardownDays,
    this.eventStatus,
    required this.clientId,
    required this.locationId,
    this.eventTime,
    this.beneficiaryPayerName,
    this.eventAddress,
    this.clientName,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id_evento'],
      beneficiaryAndPayer: json['beneficiario_e_pagador_evento'],
      eventType: json['tipo_evento'],
      eventDate: DateTime.parse(json['data_evento']),
      setupDays: json['qtd_dias_montagem_evento'],
      teardownDays: json['qtd_dias_desmontagem_evento'],
      eventStatus: json['status_evento'],
      clientId: json['id_cliente'],
      locationId: json['id_local'],
      eventTime: json['hora_evento'],
      beneficiaryPayerName: json['nome_beneficiario_pagador_evento'],
      // Assuming 'locais' and 'clientes' data comes via a join or separate fetch
      eventAddress: json['locais']?['endereco_local'], // Access nested 'endereco' from 'locais'
      clientName: json['clientes']?['nome_razao_social'], // Access nested 'nome_cliente' from 'clientes'
    );
  }
}