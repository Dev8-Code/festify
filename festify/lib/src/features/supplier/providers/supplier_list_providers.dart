import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/supplier_model.dart';

final supplierListProvider = FutureProvider<List<Supplier>>((ref) async {
  try {
    print('Iniciando busca de fornecedores...');

    final response =
        await Supabase.instance.client.from('fornecedores').select();

    print('Tipo da resposta: ${response.runtimeType}');
    print('Quantidade de registros: ${response.length}');

    if (response.isEmpty) {
      print('Nenhum registro encontrado no banco');
      return [];
    }

    final data = response as List<dynamic>;
    final suppliers =
        data.map((item) {
          return Supplier.fromMap(item);
        }).toList();

    return suppliers;
  } catch (e, stackTrace) {
    print('Erro ao buscar fornecedores: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
});
