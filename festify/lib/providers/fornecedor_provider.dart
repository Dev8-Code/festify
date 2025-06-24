import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/fornecedor_model.dart';

final supabase = Supabase.instance.client;

final fornecedoresProvider = FutureProvider<List<Fornecedor>>((ref) async {
  final response = await supabase.from('fornecedores').select();
  if (response.error != null) throw Exception(response.error!.message);
  return (response.data as List)
      .map((e) => Fornecedor.fromMap(e))
      .toList();
});

final criarFornecedorProvider = Provider((ref) => (Fornecedor fornecedor) async {
  final uid = supabase.auth.currentUser!.id;
  final response = await supabase.from('fornecedores').insert(fornecedor.toMap(uid));
  if (response.error != null) throw Exception(response.error!.message);
  ref.invalidate(fornecedoresProvider);
});

final atualizarFornecedorProvider = Provider((ref) => (String id, Fornecedor novo) async {
  final response = await supabase
      .from('fornecedores')
      .update({
        'nome': novo.nome,
        'tipo': novo.tipo,
        'contato': novo.contato,
        'telefone': novo.telefone,
      })
      .eq('id_forn', id);
  if (response.error != null) throw Exception(response.error!.message);
  ref.invalidate(fornecedoresProvider);
});

final deletarFornecedorProvider = Provider((ref) => (String id) async {
  final response = await supabase
      .from('fornecedores')
      .delete()
      .eq('id_forn', id);
  if (response.error != null) throw Exception(response.error!.message);
  ref.invalidate(fornecedoresProvider);
});