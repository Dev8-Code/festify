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
      final response = await supabase
          .from('usuarios')
          .select()
          .eq('permissao_usuario', 'operador'); // Filtrar apenas operadores

      if (response.isEmpty) {
        state = [];
        return;
      }

      final data = response as List<dynamic>;
      final operators = data.map((item) => Operator.fromMap(item)).toList();

      state = operators;
    } catch (e) {
      state = []; // Garantir que o estado seja uma lista vazia em caso de erro
    }
  }

  /// Deleta um operador pelo id_usuario (UUID)
  Future<void> deleteOperator(String idUsuario) async {
    try {
      state = state.where((op) => op.idUsuario != idUsuario).toList();

      print('Operador $idUsuario removido do estado local.');
    } catch (e) {
      print('Erro ao remover operador do estado: $e');
      // Recarregar a lista em caso de erro
      await loadOperators();
    }
  }

  /// Adiciona um novo operador ao estado (após cadastro bem-sucedido)
  void addOperator(Operator operator) {
    state = [...state, operator];
  }

  /// Recarrega a lista de operadores
  Future<void> refresh() async {
    await loadOperators();
  }
}

final operatorListProvider =
    StateNotifierProvider<OperatorListNotifier, List<Operator>>(
      (ref) => OperatorListNotifier(),
    );
