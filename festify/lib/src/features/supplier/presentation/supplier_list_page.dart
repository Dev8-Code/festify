import 'package:festify/src/features/supplier/services/supplier_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/supplier_list_providers.dart';

class SupplierListPage extends ConsumerStatefulWidget {
  const SupplierListPage({super.key});

  @override
  ConsumerState<SupplierListPage> createState() => _SupplierListPageState();
}

class _SupplierListPageState extends ConsumerState<SupplierListPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final suppliersAsync = ref.watch(supplierListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fornecedores'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar fornecedor...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: suppliersAsync.when(
              data: (suppliers) {
                final filteredSuppliers =
                    suppliers.where((supplier) {
                      if (searchQuery.isEmpty) return true;
                      return supplier.nomeFornecedor.toLowerCase().contains(
                            searchQuery,
                          ) ||
                          supplier.razaoSocialFornecedor.toLowerCase().contains(
                            searchQuery,
                          ) ||
                          supplier.cnpjFornecedor.toLowerCase().contains(
                            searchQuery,
                          );
                    }).toList();

                if (filteredSuppliers.isEmpty) {
                  return Center(
                    child: Text(
                      searchQuery.isEmpty
                          ? 'Nenhum fornecedor encontrado.'
                          : 'Nenhum fornecedor encontrado para "$searchQuery".',
                    ),
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredSuppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = filteredSuppliers[index];
                    final firstLetter =
                        supplier.nomeFornecedor.isNotEmpty
                            ? supplier.nomeFornecedor[0].toUpperCase()
                            : '?';

                    return Dismissible(
                      key: Key(supplier.idFornecedor.toString()),
                      direction: DismissDirection.endToStart,
                      background: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: Text(
                                'Deseja excluir "${supplier.nomeFornecedor}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: const Text('Excluir'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (_) async {
                        await deleteFornecedor(
                          context: context,
                          idFornecedor: supplier.idFornecedor,
                        );

                        try {
                          await ref
                              .read(supplierListProvider.notifier)
                              .deleteSupplier(supplier.idFornecedor);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Fornecedor "${supplier.nomeFornecedor}" excluído.',
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao excluir fornecedor: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber,
                            child: Text(
                              firstLetter,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          title: Text(supplier.nomeFornecedor),
                          subtitle: Text(
                            '${supplier.razaoSocialFornecedor}\n${supplier.cnpjFornecedor}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.person_outline),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Erro: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/register-supplier');
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
