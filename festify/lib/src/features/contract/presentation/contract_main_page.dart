import 'package:festify/src/features/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../providers/contract_providers.dart';
import '../services/contract_service.dart';

class ContractMainPage extends ConsumerStatefulWidget {
  const ContractMainPage({super.key});

  @override
  ConsumerState<ContractMainPage> createState() => _ContractMainPageState();
}

class _ContractMainPageState extends ConsumerState<ContractMainPage> {
  String searchQuery = '';
  String selectedFilter = '';

  @override
  Widget build(BuildContext context) {
    final contracts = ref.watch(contractListProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDarkMode ? Colors.white : Colors.black;

    final filteredContracts =
        contracts.where((contract) {
          if (searchQuery.isEmpty && selectedFilter.isEmpty) return true;

          bool matchesSearch = true;
          bool matchesFilter = true;

          if (searchQuery.isNotEmpty) {
            final nomeCliente =
                contract['clientes']?['nome_razao_social_cliente']
                    ?.toString()
                    .toLowerCase() ??
                '';
            final nomeBeneficiario =
                contract['nome_beneficiario_pagador_evento']
                    ?.toString()
                    .toLowerCase() ??
                '';
            final tipoEvento =
                contract['tipo_evento']?.toString().toLowerCase() ?? '';

            matchesSearch =
                nomeCliente.contains(searchQuery.toLowerCase()) ||
                nomeBeneficiario.contains(searchQuery.toLowerCase()) ||
                tipoEvento.contains(searchQuery.toLowerCase());
          }

          if (selectedFilter.isNotEmpty) {
            final status = ContractService.traduzirStatus(
              contract['status_evento'] ?? '',
            );
            matchesFilter = status == selectedFilter;
          }

          return matchesSearch && matchesFilter;
        }).toList();

    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const MyDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Contratos de Eventos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: Color(0xFFBDBDBD),
              ),
            ),
            SizedBox(height: 40),
            ContractSearchBar(
              onSearchChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ContractFilter(
                    'Pendente de geração',
                    isSelected: selectedFilter == 'Pendente de geração',
                    onTap: () {
                      setState(() {
                        selectedFilter =
                            selectedFilter == 'Pendente de geração'
                                ? ''
                                : 'Pendente de geração';
                      });
                    },
                  ),
                  ContractFilter(
                    'Gerado',
                    isSelected: selectedFilter == 'Gerado',
                    onTap: () {
                      setState(() {
                        selectedFilter =
                            selectedFilter == 'Gerado' ? '' : 'Gerado';
                      });
                    },
                  ),
                  ContractFilter(
                    'Pendente de Assinatura',
                    isSelected: selectedFilter == 'Pendente de Assinatura',
                    onTap: () {
                      setState(() {
                        selectedFilter =
                            selectedFilter == 'Pendente de Assinatura'
                                ? ''
                                : 'Pendente de Assinatura';
                      });
                    },
                  ),
                  ContractFilter(
                    'Assinado',
                    isSelected: selectedFilter == 'Assinado',
                    onTap: () {
                      setState(() {
                        selectedFilter =
                            selectedFilter == 'Assinado' ? '' : 'Assinado';
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child:
                  filteredContracts.isEmpty
                      ? Center(
                        child: Text(
                          searchQuery.isEmpty && selectedFilter.isEmpty
                              ? 'Nenhum contrato encontrado.'
                              : 'Nenhum contrato encontrado para os filtros selecionados.',
                          style: TextStyle(color: textColor),
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: () async {
                          await ref
                              .read(contractListProvider.notifier)
                              .refresh();
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: filteredContracts.length,
                          itemBuilder: (context, index) {
                            final contract = filteredContracts[index];
                            return Dismissible(
                              key: Key(contract['id_evento'].toString()),
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
                                        'Deseja excluir o contrato do evento "${contract['nome_beneficiario_pagador_evento']}"?',
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
                                              () => Navigator.of(
                                                context,
                                              ).pop(true),
                                          child: const Text('Excluir'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (_) async {
                                ref
                                    .read(contractListProvider.notifier)
                                    .deleteContract(contract['id_evento']);

                                final result =
                                    await ContractService.excluirEvento(
                                      context: context,
                                      idEvento: contract['id_evento'],
                                    );

                                if (result != 'success') {
                                  await ref
                                      .read(contractListProvider.notifier)
                                      .refresh();
                                }
                              },
                              child: ContractCard(contract: contract),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class ContractFilter extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ContractFilter(
    this.text, {
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.white,
            width: .5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class ContractSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;

  const ContractSearchBar({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Icon(Icons.search, color: Colors.white),
          ),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Pesquisar contratos...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: onSearchChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class ContractCard extends StatelessWidget {
  final Map<String, dynamic> contract;

  const ContractCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final nomeCliente =
        contract['clientes']?['nome_razao_social'] ?? 'Cliente não encontrado';
    final nomeBeneficiario = contract['nome_beneficiario_pagador_evento'] ?? '';
    final dataEvento = ContractService.formatarData(
      contract['data_evento'] ?? '',
    );
    final status = ContractService.traduzirStatus(
      contract['status_evento'] ?? '',
    );
    final tipoEvento = contract['tipo_evento'] ?? '';

    return GestureDetector(
      onTap: () {
        // Define o ID do contrato selecionado no provider
        final ref = ProviderScope.containerOf(context);
        ref.read(selectedContractIdProvider.notifier).state =
            contract['id_evento'];
        Navigator.pushNamed(context, '/contract-details');
      },
      child: Card(
        color: Color(0xFF1E1E1E),
        margin: EdgeInsets.only(bottom: 12),
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tipoEvento,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Contratante: $nomeCliente',
                        style: TextStyle(
                          color: Color(0xFFD4D9E0),
                          fontSize: 14,
                        ),
                      ),
                      if (nomeBeneficiario.isNotEmpty) ...[
                        SizedBox(height: 2),
                        Text(
                          'Beneficiário: $nomeBeneficiario',
                          style: TextStyle(
                            color: Color(0xFFD4D9E0),
                            fontSize: 14,
                          ),
                        ),
                      ],
                      SizedBox(height: 2),
                      Text(
                        dataEvento,
                        style: TextStyle(
                          color: Color(0xFFD4D9E0),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          contract['status_evento'],
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: _getStatusColor(contract['status_evento']),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pendente':
        return Colors.orange;
      case 'gerado':
        return Colors.blue;
      case 'assinado':
        return Colors.green;
      case 'pendente_assinatura':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
