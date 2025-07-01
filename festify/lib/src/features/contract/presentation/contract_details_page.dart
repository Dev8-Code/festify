import 'package:festify/src/features/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../../card_basic_structure.dart';
import '../providers/contract_providers.dart';
import '../services/contract_service.dart';

class ContractDetailsPage extends ConsumerWidget {
  const ContractDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContractAsync = ref.watch(selectedContractProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const MyDrawer(),
      body: selectedContractAsync.when(
        data: (contract) {
          if (contract == null) {
            return Center(
              child: Text(
                'Contrato não encontrado',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final status = contract['status_evento'] ?? '';
          final nomeCliente =
              contract['clientes']?['nome_razao_social'] ??
              'Cliente não encontrado';
          final dataEvento = ContractService.formatarData(
            contract['data_evento'] ?? '',
          );
          final tipoEvento = contract['tipo_evento'] ?? '';
          final nomeBeneficiario =
              contract['nome_beneficiario_pagador_evento'] ?? '';

          return ListView(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 12),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    color: Color.fromARGB(255, 229, 225, 225),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Informações do contrato
                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tipoEvento,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Cliente: $nomeCliente',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                if (nomeBeneficiario.isNotEmpty) ...[
                                  SizedBox(height: 4),
                                  Text(
                                    'Beneficiário: $nomeBeneficiario',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                                SizedBox(height: 4),
                                Text(
                                  'Data do Evento: $dataEvento',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 36),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Status: ${ContractService.traduzirStatus(status)}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 229, 225, 225),
                                  fontSize: 15,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        ContractStepPending(statusEvento: status),
                        ContractStepGenerated(statusEvento: status),
                        ContractStepSignature(statusEvento: status),
                        ContractStepSigned(statusEvento: status),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Text(
                'Erro ao carregar contrato: $error',
                style: TextStyle(color: Colors.red),
              ),
            ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class ContractStepSigned extends StatelessWidget {
  final String statusEvento;

  const ContractStepSigned({super.key, required this.statusEvento});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(Icons.circle_outlined, color: Colors.amber, size: 40),
          ],
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Assinado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 120),
      ],
    );
  }
}

class ContractStepSignature extends StatelessWidget {
  final String statusEvento;

  const ContractStepSignature({super.key, required this.statusEvento});

  @override
  Widget build(BuildContext context) {
    final isActive = statusEvento.toLowerCase() == 'pendente_assinatura';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(Icons.circle_outlined, color: Colors.amber, size: 40),
            SizedBox(height: 4),
            Container(width: 2, height: 60, color: Colors.amber),
          ],
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pendente de assinatura',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 80,
              width: MediaQuery.of(context).size.width * 0.6,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ContractButtons(
                      icon: Icons.upload_file,
                      text: 'Upload de arquivos',
                      isEnabled: isActive,
                    ),
                    ContractButtons(
                      icon: Icons.note_alt,
                      text: 'Assinar contrato',
                      isEnabled: isActive,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 120),
      ],
    );
  }
}

class ContractStepGenerated extends StatelessWidget {
  final String statusEvento;

  const ContractStepGenerated({super.key, required this.statusEvento});

  @override
  Widget build(BuildContext context) {
    final isActive = statusEvento.toLowerCase() == 'gerado';
    final isPassed = [
      'pendente_assinatura',
      'assinado',
    ].contains(statusEvento.toLowerCase());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(Icons.edit_rounded, color: Colors.amber, size: 40),
            SizedBox(height: 4),
            Container(width: 2, height: 60, color: Colors.amber),
          ],
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Gerado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            ContractButtons(
              icon: Icons.download,
              text: 'Baixar contrato',
              isEnabled: isActive || isPassed,
            ),
          ],
        ),
        SizedBox(height: 120),
      ],
    );
  }
}

class ContractStepPending extends StatelessWidget {
  final String statusEvento;

  const ContractStepPending({super.key, required this.statusEvento});

  @override
  Widget build(BuildContext context) {
    final isActive = statusEvento.toLowerCase() == 'pendente';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(Icons.check_rounded, color: Colors.amber, size: 50),
            SizedBox(height: 4),
            Container(width: 2, height: 60, color: Colors.amber),
          ],
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pendente de geração',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            ContractButtons(
              icon: Icons.note_add,
              text: 'Gerar contrato',
              isEnabled: isActive,
            ),
          ],
        ),
        SizedBox(height: 120),
      ],
    );
  }
}

class ContractButtons extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isEnabled;

  const ContractButtons({
    super.key,
    required this.icon,
    required this.text,
    this.isEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ElevatedButton(
        onPressed:
            isEnabled
                ? () {
                  // TODO: Implementar ações dos botões
                  print('Botão pressionado: $text');
                }
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          iconSize: 35,
          elevation: 50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  isEnabled
                      ? Colors.white
                      : const Color.fromARGB(71, 255, 255, 255),
            ),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    isEnabled
                        ? Colors.white
                        : const Color.fromRGBO(71, 255, 255, 255),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
