import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festify/src/features/custom_app_bar.dart';
import 'package:festify/src/features/custom_bottom_nav_bar.dart';
import 'package:festify/src/features/operator/providers/register_operator_providers.dart';

class RegisterOperatorPage extends ConsumerWidget {
  const RegisterOperatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nome = ref.watch(nomeOperadorProvider);
    final cpf = ref.watch(cpfOperadorProvider);
    final email = ref.watch(emailOperadorProvider);
    final telefone = ref.watch(telefoneOperadorProvider);
    final senha = ref.watch(senhaOperadorProvider);
    final repetirSenha = ref.watch(repetirSenhaOperadorProvider);
    final senhaVisivel = ref.watch(senhaVisivelOperadorProvider);
    final repetirSenhaVisivel = ref.watch(repetirSenhaVisivelOperadorProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color(0xFF121E30),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'CADASTRO OPERADOR',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildInput(ref, 'Nome', nomeOperadorProvider),
            _buildInput(ref, 'CPF', cpfOperadorProvider),
            _buildInput(ref, 'E-mail', emailOperadorProvider),
            _buildInput(ref, 'Telefone', telefoneOperadorProvider),
            _buildPasswordInput(
              ref,
              'Senha',
              senhaOperadorProvider,
              senhaVisivelOperadorProvider,
            ),
            _buildPasswordInput(
              ref,
              'Digite a senha novamente',
              repetirSenhaOperadorProvider,
              repetirSenhaVisivelOperadorProvider,
            ),

            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if ([
                    nome,
                    cpf,
                    email,
                    telefone,
                    senha,
                    repetirSenha,
                  ].any((e) => e.isEmpty)) {
                    _showMessage(context, 'Preencha todos os campos');
                    return;
                  }
                  if (senha != repetirSenha) {
                    _showMessage(context, 'As senhas não coincidem');
                    return;
                  }

                  _showMessage(context, 'Operador cadastrado com sucesso!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Enviar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
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
        onChanged: (val) => ref.read(provider.notifier).state = val,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFC107), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInput(
    WidgetRef ref,
    String label,
    StateProvider<String> textProvider,
    StateProvider<bool> visibilidadeProvider,
  ) {
    final visivel = ref.watch(visibilidadeProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        obscureText: !visivel,
        onChanged: (val) => ref.read(textProvider.notifier).state = val,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          suffixIcon: IconButton(
            icon: Icon(
              visivel ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70,
            ),
            onPressed: () {
              ref.read(visibilidadeProvider.notifier).state = !visivel;
            },
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFC107), width: 2),
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
