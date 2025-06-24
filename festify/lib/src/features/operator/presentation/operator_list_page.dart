import 'package:festify/src/features/custom_drawer.dart';
import 'package:festify/src/features/custom_app_bar.dart';
import 'package:festify/src/features/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/operator_model.dart';
import '../providers/operator_list_providers.dart';

class OperatorListPage extends ConsumerStatefulWidget {
  const OperatorListPage({super.key});

  @override
  ConsumerState<OperatorListPage> createState() => _OperatorListPageState();
}

class _OperatorListPageState extends ConsumerState<OperatorListPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final operatorsAsync = ref.watch(operatorListProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;
    final borderColor = isDarkMode ? Colors.white30 : Colors.black26;

    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const MyDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Center(
            child: Text(
              'OPERADORES',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Pesquisar operador...',
                hintStyle: TextStyle(color: subtitleColor),
                prefixIcon: Icon(Icons.search, color: subtitleColor),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.transparent,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: operatorsAsync.when(
              data: (operators) {
                // Filtrar operadores baseado na pesquisa
                final filteredOperators =
                    operators.where((operator) {
                      if (searchQuery.isEmpty) return true;
                      return operator.nomeRazaoSocial.toLowerCase().contains(
                            searchQuery,
                          ) ||
                          operator.emailUsuario.toLowerCase().contains(
                            searchQuery,
                          ) ||
                          operator.cpfUsuario.toLowerCase().contains(
                            searchQuery,
                          );
                    }).toList();

                if (filteredOperators.isEmpty) {
                  return Center(
                    child: Text(
                      searchQuery.isEmpty
                          ? 'Nenhum operador encontrado.'
                          : 'Nenhum operador encontrado para "$searchQuery".',
                      style: TextStyle(color: textColor),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredOperators.length,
                  itemBuilder: (context, index) {
                    final operator = filteredOperators[index];

                    // Pegar primeira letra do nome do operador
                    final firstLetter =
                        operator.nomeRazaoSocial.isNotEmpty
                            ? operator.nomeRazaoSocial[0].toUpperCase()
                            : '?';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
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
                        title: Text(
                          operator.nomeRazaoSocial,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              operator.emailUsuario,
                              style: TextStyle(
                                fontSize: 13,
                                color: subtitleColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'CPF: ${operator.cpfUsuario}',
                              style: TextStyle(
                                fontSize: 13,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.person_outline,
                          color: subtitleColor,
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, _) => Center(
                    child: Text(
                      'Erro: $error',
                      style: TextStyle(color: textColor),
                    ),
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/register-operator');
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
