import 'package:festify/src/features/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/custom_app_bar.dart';
import '../../features/custom_bottom_nav_bar.dart';
import '../providers/cadastro_pagamento_providers.dart';


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
      appBar: CustomAppBar(),
      endDrawer: const MyDrawer(),
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
            _buildDatePicker(context, ref),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade700,
                borderRadius: BorderRadius.circular(50),
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
                          backgroundColor: Colors.amber,
                          foregroundColor: const Color(0xFF121E30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white70),
            
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12) ,
            borderSide: BorderSide(color: Colors.amber),
            
            
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
          enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.amber, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, WidgetRef ref) {
  final data = ref.watch(dataVencimentoProvider);

  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          locale: const Locale('pt', 'BR'),
        );
        if (picked != null) {
          final dataFormatada = '${picked.day.toString().padLeft(2, '0')}/'
              '${picked.month.toString().padLeft(2, '0')}/'
              '${picked.year}';
          ref.read(dataVencimentoProvider.notifier).state = dataFormatada;
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(text: data),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Data vencimento',
            labelStyle: const TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white70),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.amber, width: 2),
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
          ),
        ),
      ),
    ),
  );
}

}
