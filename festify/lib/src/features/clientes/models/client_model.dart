class Client {
  final int idCliente;
  final String nomeRazaoSocial;
  final String tipoCliente;
  final String cpfCliente;
  final String emailCliente;
  final String enderecoCliente;
  final String? rgCliente;
  final String? responsavelCliente;
  final DateTime? dataNascCliente;
  final String? telCliente; 

  Client({
    required this.idCliente,
    required this.nomeRazaoSocial,
    required this.tipoCliente,
    required this.cpfCliente,
    required this.emailCliente,
    required this.enderecoCliente,
    this.rgCliente,
    this.responsavelCliente,
    this.dataNascCliente,
    this.telCliente,
  });

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      idCliente: map['id_cliente'],
      nomeRazaoSocial: map['nome_razao_social'],
      tipoCliente: map['tipo_cliente'], // assume que não é nulo no banco
      cpfCliente: map['cpf_cliente'],
      emailCliente: map['email_cliente'],
      enderecoCliente: map['endereco_cliente'],
      rgCliente: map['rg_cliente'],
      responsavelCliente: map['responsavel_cliente'],
      dataNascCliente: map['data_nasc_cliente'] != null
          ? DateTime.tryParse(map['data_nasc_cliente'])
          : null,
      telCliente: map['tel_cliente'],
    );
  }
}
