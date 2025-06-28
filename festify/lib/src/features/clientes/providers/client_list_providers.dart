// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/client_model.dart';

class ClientListNotifier extends AsyncNotifier<List<Client>> {
  @override
  Future<List<Client>> build() async {
    return await _fetchClients();
  }

 Future<List<Client>> _fetchClients() async {
  try {
    final response = await Supabase.instance.client.from('clientes').select();

    // Adicione os prints aqui, ainda dentro do try
    print('Resposta do Supabase: $response');

    final data = response as List<dynamic>;
    print('Número de clientes recebidos: ${data.length}');

    return data.map((item) => Client.fromMap(item)).toList();
  } catch (e, stackTrace) {
    print('Erro ao buscar clientes: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}

  Future<void> deleteClient(int idCliente) async {
    try {
      // Remove localmente
      state = AsyncData(
        state.value!.where((c) => c.idCliente != idCliente).toList(),
      );

      // Remove do Supabase
      await Supabase.instance.client
          .from('clientes')
          .delete()
          .eq('id_cliente', idCliente);
    } catch (e) {
      // Recarrega se falhar
      state = const AsyncLoading();
      final refreshed = await _fetchClients();
      state = AsyncData(refreshed);

      throw Exception('Erro ao deletar cliente: $e');
    }
  }
}
final clientListProvider =
    AsyncNotifierProvider<ClientListNotifier, List<Client>>(
  () => ClientListNotifier(),
);
