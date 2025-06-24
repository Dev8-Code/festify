class Fornecedor {
  final String id;
  final String nome;
  final String tipo;
  final String contato;
  final String telefone;

  Fornecedor({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.contato,
    required this.telefone,
  });

  factory Fornecedor.fromMap(Map<String, dynamic> map) => Fornecedor(
        id: map['id_forn'],
        nome: map['nome'],
        tipo: map['tipo'],
        contato: map['contato'],
        telefone: map['telefone'],
      );

  Map<String, dynamic> toMap(String idUsuar) => {
        'id_usuar': idUsuar,
        'nome': nome,
        'tipo': tipo,
        'contato': contato,
        'telefone': telefone,
      };
}