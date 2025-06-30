import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/contract_service.dart';

class ContractListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ContractListNotifier() : super([]) {
    loadContracts();
  }

  Future<void> loadContracts() async {
    final contracts = await ContractService.buscarEventosComClientes();
    state = contracts;
  }

  Future<void> refresh() async {
    await loadContracts();
  }

  void deleteContract(int idEvento) {
    state =
        state.where((contract) => contract['id_evento'] != idEvento).toList();
  }
}

final contractListProvider =
    StateNotifierProvider<ContractListNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return ContractListNotifier();
    });

// Provider para contrato selecionado (para a página de detalhes)
final selectedContractIdProvider = StateProvider<int?>((ref) => null);

final selectedContractProvider = FutureProvider<Map<String, dynamic>?>((
  ref,
) async {
  final selectedId = ref.watch(selectedContractIdProvider);
  if (selectedId == null) return null;
  return await ContractService.buscarEventoPorIdComCliente(selectedId);
});
