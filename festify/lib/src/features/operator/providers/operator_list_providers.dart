import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/operator_model.dart';

final operatorListProvider = FutureProvider<List<Operator>>((ref) async {
  try {
    print('Iniciando busca de operadores...');

    final response = await Supabase.instance.client.from('usuarios').select();

    print('Tipo da resposta: ${response.runtimeType}');
    print('Quantidade de registros: ${response.length}');

    if (response.isEmpty) {
      print('Nenhum registro encontrado no banco');
      return [];
    }

    final data = response as List<dynamic>;
    final operators =
        data.map((item) {
          return Operator.fromMap(item);
        }).toList();

    return operators;
  } catch (e, stackTrace) {
    print('Erro ao buscar operadores: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
});
