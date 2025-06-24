class Supplier {
  final int idFornecedor;
  final String nomeFornecedor;
  final String razaoSocialFornecedor;
  final String cnpjFornecedor;
  final String emailFornecedor;

  Supplier({
    required this.idFornecedor,
    required this.nomeFornecedor,
    required this.razaoSocialFornecedor,
    required this.cnpjFornecedor,
    required this.emailFornecedor,
  });

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      idFornecedor: map['id_fornecedor'] as int,
      nomeFornecedor: map['nome_fornecedor'] ?? '',
      razaoSocialFornecedor: map['razao_social_fornecedor'] ?? '',
      cnpjFornecedor: map['cnpj_fornecedor'] ?? '',
      emailFornecedor: map['email_fornecedor'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_fornecedor': idFornecedor,
      'nome_fornecedor': nomeFornecedor,
      'razao_social_fornecedor': razaoSocialFornecedor,
      'cnpj_fornecedor': cnpjFornecedor,
      'email_fornecedor': emailFornecedor,
    };
  }
}
