import 'package:festify/src/features/custom_app_bar.dart';
import 'package:festify/src/features/custom_bottom_nav_bar.dart';
import 'package:festify/src/features/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cadastro_evento_providers.dart';


class CadastroEventoPage extends ConsumerWidget {
  const CadastroEventoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipoEvento = ref.watch(tipoEventoProvider);
    final diasMontagem = ref.watch(diasMontagemProvider);
    final pagadorBeneficiario = ref.watch(pagadorBeneficiarioProvider);
    final isLoading = ref.watch(isLoadingCadastroEventoProvider);

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
              'Preencha os campos abaixo',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 24),
            _buildInput(ref, 'Tipo de evento', tipoEventoProvider),
            _buildInput(ref, 'Qtde de dias para montagem/desmontagem', diasMontagemProvider),

            const SizedBox(height: 16),
            const Text(
              'O pagador é o beneficiário?',
              style: TextStyle(color: Colors.white70),
            ),
            Row(
              children: [
                Checkbox(
                  value: pagadorBeneficiario == true,
                  onChanged: (value) {
                    if (value == true) {
                      ref.read(pagadorBeneficiarioProvider.notifier).state = true;
                    }
                  },
                ),
                const Text('Sim', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 16),
                Checkbox(
                  value: pagadorBeneficiario == false,
                  onChanged: (value) {
                    if (value == true) {
                      ref.read(pagadorBeneficiarioProvider.notifier).state = false;
                    }
                  },
                ),
                const Text('Não', style: TextStyle(color: Colors.white)),
              ],
            ),

            const SizedBox(height: 16),
            _buildInput(ref, 'Beneficiário/Pagador', beneficiarioProvider),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.yellow))
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        foregroundColor: const Color(0xFF121E30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if ([tipoEvento, diasMontagem, ref.read(beneficiarioProvider)].any((e) => e.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Preencha todos os campos')),
                          );
                          return;
                        }

                        ref.read(isLoadingCadastroEventoProvider.notifier).state = true;
                        await Future.delayed(const Duration(seconds: 1)); // Simula carregamento
                        ref.read(isLoadingCadastroEventoProvider.notifier).state = false;

                        // Exibe sucesso (opcional)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Evento salvo! Indo para pagamento...')),
                        );

                        // Navegar para tela de pagamento
                        Navigator.of(context).pushNamed('/cadastro-pagamento');
                      },

                      child: const Text('Ir para pagamento'),
                    ),
            ),
          ],
        ),
      ),
            bottomNavigationBar: CustomBottomNavBar(),

    );
  }

  Widget _buildInput(WidgetRef ref, String label, StateProvider<String> provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
            borderSide: BorderSide(color: Colors.amber, width: 2.0),
          ),
        ),
      ),
    );
  }
}
