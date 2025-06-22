import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/custom_app_bar.dart';
import '../../features/custom_bottom_nav_bar.dart';
import '../../features/custom_drawer.dart';
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

    final textColor = Theme.of(context).textTheme.bodyLarge?.color;


    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const MyDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Text(
              'Preencha as informações de pagamento',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            _buildCurrencyInput(ref, context, 'Valor contrato', valorContratoProvider),
            _buildCurrencyInput(ref, context, 'Valor pago', valorPagoProvider),
            _buildInput(ref, context, 'Qtde parcelas', qtdeParcelasProvider),
            _buildDatePicker(context, ref),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                'Status: pendente de pagamento',
                style: TextStyle(color: textColor),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: const Color(0xFF121E30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                      ),
                      onPressed: () async {
                        if ([valorContrato, valorPago, qtdeParcelas, dataVencimento].any((e) => e.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Preencha todos os campos')),
                          );
                          return;
                        }

                        ref.read(isLoadingCadastroPagamentoProvider.notifier).state = true;
                        await Future.delayed(const Duration(seconds: 2));
                        ref.read(isLoadingCadastroPagamentoProvider.notifier).state = false;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pagamento cadastrado com sucesso!')),
                        );
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
  BuildContext context,
  String label,
  StateProvider<String> provider,
) {
  final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
  final labelColor = Theme.of(context).textTheme.labelLarge?.color ?? Colors.black;
  final borderColor = Theme.of(context).colorScheme.outline;

  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      style: TextStyle(color: textColor),
      onChanged: (value) => ref.read(provider.notifier).state = value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: labelColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
    ),
  );
}


  Widget _buildCurrencyInput(
    WidgetRef ref,
    BuildContext context,
    String label,
    StateProvider<String> provider,
  ) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        keyboardType: TextInputType.number,
        style: TextStyle(color: textColor),
        onChanged: (value) => ref.read(provider.notifier).state = value,
        decoration: InputDecoration(
          prefixText: 'R\$ ',
          prefixStyle: TextStyle(color: textColor),
          labelText: label,
          labelStyle: TextStyle(color: Theme.of(context).textTheme.labelLarge?.color),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataVencimentoProvider);
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

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
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: 'Data vencimento',
              labelStyle: TextStyle(color: Theme.of(context).textTheme.labelLarge?.color),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              suffixIcon: Icon(Icons.calendar_today, color: Theme.of(context).iconTheme.color),
            ),
          ),
        ),
      ),
    );
  }
}
