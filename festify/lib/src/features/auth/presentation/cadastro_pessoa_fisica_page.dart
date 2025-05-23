import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cadastro_pessoa_fisica_providers.dart';
import '../../custom_app_bar.dart';

class CadastroPessoaFisicaPage extends ConsumerWidget {
  const CadastroPessoaFisicaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nome = ref.watch(nomeProvider);
    final cpf = ref.watch(cpfProvider);
    final rg = ref.watch(rgProvider);
    final email = ref.watch(emailProvider);
    final telefone = ref.watch(telefoneProvider);
    final isLoading = ref.watch(isLoadingCadastroProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121E30),
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'CADASTRO PESSOA FÍSICA',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Campos de entrada
            _buildInput(context, ref, 'Nome', nomeProvider),
            _buildInput(context, ref, 'CPF', cpfProvider),
            _buildInput(context, ref, 'RG', rgProvider),
            _buildInput(context, ref, 'E-mail', emailProvider),
            _buildInput(context, ref, 'Telefone', telefoneProvider),

            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 500,
                height: 50,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.yellow))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          foregroundColor: const Color(0xFF121E30),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        onPressed: () async {
                          if ([nome, cpf, rg, email, telefone].any((e) => e.isEmpty)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Por favor, preencha todos os campos')),
                            );
                            return;
                          }

                          ref.read(isLoadingCadastroProvider.notifier).state = true;
                          await Future.delayed(const Duration(seconds: 2));
                          ref.read(isLoadingCadastroProvider.notifier).state = false;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cadastro realizado com sucesso!')),
                          );
                        },
                        child: const Text('Cadastrar'),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121E30),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Cadastro'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Contratos'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context, WidgetRef ref, String label, StateProvider<String> provider) {
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
            borderSide: BorderSide(color: Colors.yellow),
          ),
        ),
      ),
    );
  }
}
