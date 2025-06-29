import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../../custom_drawer.dart';
import '../models/client_model.dart';
import '../providers/client_list_providers.dart';

class ClientListPage extends ConsumerStatefulWidget {
  const ClientListPage({super.key});

  @override
  ConsumerState<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends ConsumerState<ClientListPage> {
  String searchQuery = '';
  String filter = 'Ambos';
  final ScrollController scrollController = ScrollController();

  final Map<String, int> letterIndexMap = {};
  final List<String> alphabet = List.generate(26, (i) => String.fromCharCode(65 + i));

  String? overlayLetter;
  Timer? overlayTimer;

  @override
  void dispose() {
    scrollController.dispose();
    overlayTimer?.cancel();
    super.dispose();
  }

  void showOverlayLetter(String letter) {
    setState(() {
      overlayLetter = letter;
    });
    overlayTimer?.cancel();
    overlayTimer = Timer(const Duration(seconds: 1), () {
      setState(() {
        overlayLetter = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildFilters(),
            const SizedBox(height: 20),
            Expanded(
              child: ref.watch(clientListProvider).when(
                data: (clients) {
                  final filtered = clients.where((client) {
                    final tipo = client.tipoCliente?.toLowerCase() ?? '';
                    final nomeFinal = (client.nomeRazaoSocial?.isNotEmpty ?? false)
                        ? client.nomeRazaoSocial!
                        : (client.responsavelCliente ?? client.emailCliente ?? '');

                    final matchesSearch = nomeFinal.toLowerCase().contains(searchQuery);
                    final matchesFilter = filter == 'Ambos' || tipo == filter.toLowerCase();
                    return matchesSearch && matchesFilter;
                  }).toList();

                  filtered.sort((a, b) {
                    final nameA = (a.nomeRazaoSocial?.isNotEmpty ?? false)
                        ? a.nomeRazaoSocial!
                        : (a.responsavelCliente ?? a.emailCliente ?? '');
                    final nameB = (b.nomeRazaoSocial?.isNotEmpty ?? false)
                        ? b.nomeRazaoSocial!
                        : (b.responsavelCliente ?? b.emailCliente ?? '');
                    return nameA.toLowerCase().compareTo(nameB.toLowerCase());
                  });

                  Map<String, List<Client>> grouped = {};
                  for (var client in filtered) {
                    final nomeFinal = (client.nomeRazaoSocial?.isNotEmpty ?? false)
                        ? client.nomeRazaoSocial!
                        : (client.responsavelCliente ?? client.emailCliente ?? '');
                    final firstLetter = nomeFinal.isNotEmpty ? nomeFinal[0].toUpperCase() : '#';
                    grouped.putIfAbsent(firstLetter, () => []).add(client);
                  }

                  List<Widget> listItems = [];
                  int index = 0;
                  letterIndexMap.clear();

                  grouped.forEach((letter, clients) {
                    letterIndexMap[letter] = index;

                    listItems.add(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                    index++;

                    for (var client in clients) {
                      final nomeFinal = (client.nomeRazaoSocial?.isNotEmpty ?? false)
                          ? client.nomeRazaoSocial!
                          : (client.responsavelCliente ?? client.emailCliente ?? '');
                      final firstLetter = nomeFinal.isNotEmpty ? nomeFinal[0].toUpperCase() : '?';

                      listItems.add(
                        Dismissible(
                          key: Key(client.idCliente.toString()),
                          direction: DismissDirection.endToStart,
                          background: _buildDeleteBackground(),
                          confirmDismiss: (_) => _confirmDeleteDialog(context, nomeFinal),
                          onDismissed: (_) async {
                            await ref.read(clientListProvider.notifier).deleteClient(client.idCliente);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Cliente "$nomeFinal" excluído.')),
                            );
                          },
                          child: _buildClientCard(client, firstLetter, nomeFinal),
                        ),
                      );
                      index++;
                    }
                  });

                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: ListView(
                          controller: scrollController,
                          children: listItems,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 40,
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: alphabet.map((letter) {
                              final isAvailable = grouped.containsKey(letter);
                              return Expanded(
                                child: GestureDetector(
                                  onTap: isAvailable
                                      ? () {
                                          showOverlayLetter(letter);
                                          final idx = letterIndexMap[letter] ?? 0;
                                          scrollController.animateTo(
                                            idx * 72.0,
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      : null,
                                  child: Center(
                                    child: Text(
                                      letter,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isAvailable
                                            ? (isDarkMode ? Colors.amber : Colors.blue)
                                            : (isDarkMode ? Colors.grey[700] : Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      if (overlayLetter != null)
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              overlayLetter!,
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.black54,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
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

  Widget _buildSearchBar() => Container(
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
      );

  Widget _buildFilters() => Row(
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
                style: TextStyle(color: isSelected ? Colors.black : Colors.white),
              ),
            ),
          );
        }).toList(),
      );

  Widget _buildDeleteBackground() => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ),
      );

  Future<bool?> _confirmDeleteDialog(BuildContext context, String nome) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir "$nome"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(Client client, String firstLetter, String nomeFinal) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              client.emailCliente ?? '',
              style: TextStyle(fontSize: 13, color: subtitleColor),
            ),
            if ((client.telCliente ?? '').isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                'Tel: ${client.telCliente}',
                style: TextStyle(fontSize: 13, color: subtitleColor),
              ),
            ],
          ],
        ),
        trailing: Icon(Icons.person_outline, color: subtitleColor),
      ),
    );
  }
}
