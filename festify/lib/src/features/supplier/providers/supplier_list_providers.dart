import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/supplier_model.dart';

class SupplierListNotifier extends AsyncNotifier<List<Supplier>> {
  @override
  Future<List<Supplier>> build() async {
    return await _fetchSuppliers();
  }

  Future<List<Supplier>> _fetchSuppliers() async {
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
      final suppliers = data.map((item) => Supplier.fromMap(item)).toList();

      return suppliers;
    } catch (e, stackTrace) {
      print('Erro ao buscar fornecedores: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> deleteSupplier(int id_fornecedor) async {
    state = AsyncData(
      state.value!.where((s) => s.idFornecedor != id_fornecedor).toList(),
    );

    try {
      // Executa a exclusão no backend
      await Supabase.instance.client
          .from('fornecedores')
          .delete()
          .eq('id_fornecedor', id_fornecedor)
          .select();

      // Não precisamos de uma variável para armazenar a resposta, já que não estamos utilizando
    } catch (e) {
      // Em caso de erro, recarrega lista para manter estado consistente
      state = const AsyncLoading();
      final refreshed = await _fetchSuppliers();
      state = AsyncData(refreshed);
      throw Exception('Erro ao deletar fornecedor: $e');
    }
  }
}

final supplierListProvider =
    AsyncNotifierProvider<SupplierListNotifier, List<Supplier>>(
      () => SupplierListNotifier(),
    );
