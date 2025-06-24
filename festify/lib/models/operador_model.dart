class Operador {
  final String id;
  final String nome;
  final String email;
  final String telefone;

  Operador({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
  });

  factory Operador.fromMap(Map<String, dynamic> map) => Operador(
        id: map['id_operador'],
        nome: map['nome'],
        email: map['email'],
        telefone: map['telefone'],
      );

  Map<String, dynamic> toMap(String idUsuar) => {
        'id_operador': id,
        'id_usuar': idUsuar,
        'nome': nome,
        'email': email,
        'telefone': telefone,
      };
}