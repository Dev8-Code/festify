import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/operator_model.dart';

class OperatorListNotifier extends StateNotifier<List<Operator>> {
  OperatorListNotifier() : super([]) {
    loadOperators();
  }

  final supabase = Supabase.instance.client;

  /// Carrega todos os operadores da tabela 'usuarios'
  Future<void> loadOperators() async {
    try {
      print('Iniciando busca de operadores...');

      final response = await supabase.from('usuarios').select();

      print('Tipo da resposta: ${response.runtimeType}');
      print('Quantidade de registros: ${response.length}');

      if (response.isEmpty) {
        print('Nenhum registro encontrado no banco');
        state = [];
        return;
      }

      final data = response as List<dynamic>;
      final operators = data.map((item) => Operator.fromMap(item)).toList();

      state = operators;
    } catch (e, stackTrace) {
      print('Erro ao buscar operadores: $e');
      print('Stack trace: $stackTrace');
    }
  }

  /// Deleta um operador pelo id_operador
  Future<void> deleteOperator(int idUsuario) async {
    try {
      // Deleta do banco (tabela 'usuarios' deve ter a coluna 'id_operador')
      await supabase.from('usuarios').delete().eq('idUsuario', idUsuario);

      // Remove do estado local
      state = state.where((op) => op.idUsuario != idUsuario).toList();

      print('Operador $idUsuario deletado com sucesso.');
    } catch (e) {
      print('Erro ao deletar operador: $e');
    }
  }
}

final operatorListProvider =
    StateNotifierProvider<OperatorListNotifier, List<Operator>>(
  (ref) => OperatorListNotifier(),
);
