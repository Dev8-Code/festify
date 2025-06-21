import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/supplier_model.dart';
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
                // Filtrar fornecedores baseado na pesquisa
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
                  // Permitir scroll para baixo
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredSuppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = filteredSuppliers[index];

                    // Pegar primeira letra do nome do fornecedor
                    final firstLetter =
                        supplier.nomeFornecedor.isNotEmpty
                            ? supplier.nomeFornecedor[0].toUpperCase()
                            : '?';

                    return Card(
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
                        trailing: const Icon(
                          Icons.person_outline,
                        ), // Ícone de usuário
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
