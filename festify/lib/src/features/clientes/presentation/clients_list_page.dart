import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../../custom_drawer.dart';
import '../providers/client_list_providers.dart';

class ClientListPage extends ConsumerStatefulWidget {
  const ClientListPage({super.key});

  @override
  ConsumerState<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends ConsumerState<ClientListPage> {
  String searchQuery = '';
  String filter = 'Ambos';

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientListProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo de busca
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Pesquisar...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Filtros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Físicos', 'Jurídicos', 'Ambos'].map((type) {
                final isSelected = filter == type;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      filter = type;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white, width: 0.5),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Lista de clientes
            Expanded(
              child: clientsAsync.when(
                data: (clients) {
                  final filtered = clients.where((client) {
                    final tipo = (client.tipoCliente).toLowerCase();
                    final nomeFinal = client.nomeRazaoSocial.isNotEmpty
                        ? client.nomeRazaoSocial
                        : (client.responsavelCliente ?? client.emailCliente);

                    final matchesSearch = nomeFinal.toLowerCase().contains(searchQuery);
                    final matchesFilter = filter == 'Ambos' || tipo == filter.toLowerCase();
                    return matchesSearch && matchesFilter;
                  }).toList();

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final client = filtered[index];
                      final nomeFinal = client.nomeRazaoSocial.isNotEmpty
                          ? client.nomeRazaoSocial
                          : (client.responsavelCliente ?? client.emailCliente);

                      final firstLetter = nomeFinal.isNotEmpty
                          ? nomeFinal[0].toUpperCase()
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
                                    nomeFinal,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          client.emailCliente,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        if (client.telCliente != null)
                                          Text(
                                            'Tel: ${client.telCliente}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white70,
                                            ),
                                          ),
                                      ],
                                    ),

                                  trailing: const Icon(
                                    Icons.person_outline,
                                    color: Colors.white70,
                                  ),
                                  onTap: () {
                                    // Ação ao tocar no card
                                  },
                                ),
                              );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Erro: $e')),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}