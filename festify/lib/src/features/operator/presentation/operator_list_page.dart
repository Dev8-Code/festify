import 'package:festify/src/features/custom_drawer.dart';
import 'package:festify/src/features/custom_app_bar.dart';
import 'package:festify/src/features/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/operator_list_providers.dart';
import '../services/operator_service.dart';

class OperatorListPage extends ConsumerStatefulWidget {
  const OperatorListPage({super.key});

  @override
  ConsumerState<OperatorListPage> createState() => _OperatorListPageState();
}

class _OperatorListPageState extends ConsumerState<OperatorListPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final operators = ref.watch(operatorListProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;
    final borderColor = isDarkMode ? Colors.white30 : Colors.black26;

    final filteredOperators =
        operators.where((operator) {
          if (searchQuery.isEmpty) return true;
          return operator.nomeRazaoSocial.toLowerCase().contains(searchQuery) ||
              operator.emailUsuario.toLowerCase().contains(searchQuery) ||
              operator.cpfUsuario.toLowerCase().contains(searchQuery);
        }).toList();

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
            child:
                filteredOperators.isEmpty
                    ? Center(
                      child: Text(
                        searchQuery.isEmpty
                            ? 'Nenhum operador encontrado.'
                            : 'Nenhum operador encontrado para "$searchQuery".',
                        style: TextStyle(color: textColor),
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(operatorListProvider.notifier).refresh();
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredOperators.length,
                        itemBuilder: (context, index) {
                          final operator = filteredOperators[index];
                          final firstLetter =
                              operator.nomeRazaoSocial.isNotEmpty
                                  ? operator.nomeRazaoSocial[0].toUpperCase()
                                  : '?';

                          return Dismissible(
                            key: Key(operator.idUsuario),
                            direction: DismissDirection.endToStart,
                            background: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
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
                                      'Deseja excluir "${operator.nomeRazaoSocial}"?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(
                                              context,
                                            ).pop(false),
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed:
                                            () =>
                                                Navigator.of(context).pop(true),
                                        child: const Text('Excluir'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (_) async {
                              ref
                                  .read(operatorListProvider.notifier)
                                  .deleteOperator(operator.idUsuario);

                              final result = await deleteOperator(
                                context: context,
                                idOperador: operator.idUsuario,
                              );

                              if (result != 'success') {
                                await ref
                                    .read(operatorListProvider.notifier)
                                    .refresh();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Operador "${operator.nomeRazaoSocial}" excluído.',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Card(
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
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            operator.statusUsuario == 'ativo'
                                                ? Colors.green.withOpacity(0.2)
                                                : Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        operator.statusUsuario.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              operator.statusUsuario == 'ativo'
                                                  ? Colors.green[700]
                                                  : Colors.red[700],
                                        ),
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
                            ),
                          );
                        },
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
