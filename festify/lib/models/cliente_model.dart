class Cliente {
  final String id;
  final String nome;
  final String tipo; // 'PF' ou 'PJ'
  final String documento; // CPF ou CNPJ
  final String telefone;

  Cliente({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.documento,
    required this.telefone,
  });

  factory Cliente.fromMap(Map<String, dynamic> map) => Cliente(
        id: map['id_client'],
        nome: map['nome'],
        tipo: map['tipo'],
        documento: map['documento'],
        telefone: map['telefone'],
      );

  Map<String, dynamic> toMap(String idUsuar) => {
        'id_client': id,
        'id_usuar': idUsuar,
        'nome': nome,
        'tipo': tipo,
        'documento': documento,
        'telefone': telefone,
      };
}