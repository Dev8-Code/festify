import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cadastro_pagamento_providers.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';

class CadastroPagamentoPage extends ConsumerWidget {
  const CadastroPagamentoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valorContrato = ref.watch(valorContratoProvider);
    final valorPago = ref.watch(valorPagoProvider);
    final qtdeParcelas = ref.watch(qtdeParcelasProvider);
    final dataVencimento = ref.watch(dataVencimentoProvider);
    final isLoading = ref.watch(isLoadingCadastroPagamentoProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121E30),
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Preencha as informações de pagamento',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 24),

            _buildCurrencyInput(ref, 'Valor contrato', valorContratoProvider),
            _buildCurrencyInput(ref, 'Valor pago', valorPagoProvider),
            _buildInput(ref, 'Qtde parcelas', qtdeParcelasProvider),
            _buildInput(
              ref,
              'Data vencimento (dd/mm/aaaa)',
              dataVencimentoProvider,
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Status: pendente de pagamento',
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.yellow),
                      )
                      : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          foregroundColor: const Color(0xFF121E30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          if ([
                            valorContrato,
                            valorPago,
                            qtdeParcelas,
                            dataVencimento,
                          ].any((e) => e.isEmpty)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Preencha todos os campos'),
                              ),
                            );
                            return;
                          }

                          ref
                              .read(isLoadingCadastroPagamentoProvider.notifier)
                              .state = true;
                          await Future.delayed(const Duration(seconds: 2));
                          ref
                              .read(isLoadingCadastroPagamentoProvider.notifier)
                              .state = false;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Pagamento cadastrado com sucesso!',
                              ),
                            ),
                          );

                          // Exemplo de redirecionamento após salvar
                          // Navigator.of(context).pushReplacementNamed('/home');
                        },
                        child: const Text('Cadastrar'),
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildInput(
    WidgetRef ref,
    String label,
    StateProvider<String> provider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        onChanged: (value) => ref.read(provider.notifier).state = value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyInput(
    WidgetRef ref,
    String label,
    StateProvider<String> provider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        onChanged: (value) => ref.read(provider.notifier).state = value,
        decoration: InputDecoration(
          prefixText: 'R\$ ',
          prefixStyle: const TextStyle(color: Colors.white),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
          ),
        ),
      ),
    );
  }
}
