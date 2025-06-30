class Operator {
  final String idUsuario;
  final String nomeRazaoSocial;
  final String emailUsuario;
  final String cpfUsuario;
  final String permissaoUsuario;
  final String telefoneUsuario;
  final String statusUsuario;

  Operator({
    required this.idUsuario,
    required this.nomeRazaoSocial,
    required this.emailUsuario,
    required this.cpfUsuario,
    required this.permissaoUsuario,
    required this.telefoneUsuario,
    required this.statusUsuario,
  });

  factory Operator.fromMap(Map<String, dynamic> map) {
    return Operator(
      idUsuario:
          map['id_usuario']?.toString() ?? '', // Garantir que seja String
      nomeRazaoSocial: map['nome_razao_social'] ?? '',
      emailUsuario: map['email_usuario'] ?? '',
      cpfUsuario: map['cpf_usuario'] ?? '',
      permissaoUsuario: map['permissao_usuario'] ?? '',
      telefoneUsuario: map['telefone_usuario'] ?? '',
      statusUsuario: map['status_usuario'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'nome_razao_social': nomeRazaoSocial,
      'email_usuario': emailUsuario,
      'cpf_usuario': cpfUsuario,
      'permissao_usuario': permissaoUsuario,
      'telefone_usuario': telefoneUsuario,
      'status_usuario': statusUsuario,
    };
  }
}
