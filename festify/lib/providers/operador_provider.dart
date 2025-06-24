import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'operador_model.dart';

final supabase = Supabase.instance.client;

//Buscar todos os operadores
final operadoresProvider = FutureProvider<List<Operador>>((ref) async {
  final response = await supabase.from('operadores').select();
  if (response.error != null) {
    throw Exception(response.error!.message);
  }

  final data = List<Map<String, dynamic>>.from(response.data);
  return data.map((map) => Operador.fromMap(map)).toList();
});

//Criar operador
final criarOperadorProvider = Provider((ref) => (Operador operador) async {
  final uid = supabase.auth.currentUser!.id;

  final response = await supabase.from('operadores').insert({
    'id_usuar': uid,
    'nome': operador.nome,
    'email': operador.email,
    'telefone': operador.telefone,
  });

  if (response.error != null) throw Exception(response.error!.message);
  ref.invalidate(operadoresProvider);
});

//Atualizar operador
final atualizarOperadorProvider = Provider((ref) => (String id, Operador novo) async {
  final response = await supabase.from('operadores')
    .update({
      'nome': novo.nome,
      'email': novo.email,
      'telefone': novo.telefone,
    })
    .eq('id_operador', id);

  if (response.error != null) throw Exception(response.error!.message);
  ref.invalidate(operadoresProvider);
});

//Deletar operador
final deletarOperadorProvider = Provider((ref) => (String id) async {
  final response = await supabase.from('operadores').delete().eq('id_operador', id);
  if (response.error != null) throw Exception(response.error!.message);
  ref.invalidate(operadoresProvider);
});