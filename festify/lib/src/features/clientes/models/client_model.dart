class Client {
  final int idCliente;
  final String? nomeRazaoSocial;
  final String? tipoCliente;
  final String? cpfCliente;
  final String? emailCliente;
  final String? enderecoCliente;
  final String? rgCliente;
  final String? responsavelCliente;
  final DateTime? dataNascCliente;
  final String? telCliente;

  Client({
    required this.idCliente,
    this.nomeRazaoSocial,
    this.tipoCliente,
    this.cpfCliente,
    this.emailCliente,
    this.enderecoCliente,
    this.rgCliente,
    this.responsavelCliente,
    this.dataNascCliente,
    this.telCliente,
  });

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      idCliente: map['id_cliente'] as int,
      nomeRazaoSocial: map['nome_razao_social'] as String?,
      tipoCliente: map['tipo_cliente'] as String?,
      cpfCliente: map['cpf_cliente'] as String?,
      emailCliente: map['email_cliente'] as String?,
      enderecoCliente: map['endereco_cliente'] as String?,
      rgCliente: map['rg_cliente'] as String?,
      responsavelCliente: map['responsavel_cliente'] as String?,
      dataNascCliente: map['data_nasc_cliente'] != null
          ? DateTime.tryParse(map['data_nasc_cliente'])
          : null,
      telCliente: map['tel_cliente'] as String?,
    );
  }
}
