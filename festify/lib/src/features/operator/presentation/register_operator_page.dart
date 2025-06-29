import 'package:festify/src/features/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festify/src/features/custom_app_bar.dart';
import 'package:festify/src/features/custom_bottom_nav_bar.dart';
import 'package:festify/src/features/operator/providers/register_operator_providers.dart';
import 'package:festify/src/features/operator/services/operator_service.dart';

class RegisterOperatorPage extends ConsumerWidget {
  const RegisterOperatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final nome = ref.watch(nomeOperadorProvider);
    final cpf = ref.watch(cpfOperadorProvider);
    final email = ref.watch(emailOperadorProvider);
    final telefone = ref.watch(telefoneOperadorProvider);
    final senha = ref.watch(senhaOperadorProvider);
    final repetirSenha = ref.watch(repetirSenhaOperadorProvider);
    final senhaVisivel = ref.watch(senhaVisivelOperadorProvider);
    final repetirSenhaVisivel = ref.watch(repetirSenhaVisivelOperadorProvider);

    final textColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final borderColor = isDarkMode ? Colors.white70 : Colors.black38;
    final buttonColor = Colors.amber[700]!;
    final buttonTextColor = const Color(0xFF121E30);

    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const MyDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Text(
                'CADASTRO OPERADOR',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildInput(
              ref,
              context,
              'Nome',
              nomeOperadorProvider,
              textColor,
              labelColor,
              borderColor,
            ),
            _buildInput(
              ref,
              context,
              'CPF',
              cpfOperadorProvider,
              textColor,
              labelColor,
              borderColor,
            ),
            _buildInput(
              ref,
              context,
              'E-mail',
              emailOperadorProvider,
              textColor,
              labelColor,
              borderColor,
            ),
            _buildInput(
              ref,
              context,
              'Telefone',
              telefoneOperadorProvider,
              textColor,
              labelColor,
              borderColor,
            ),
            _buildPasswordInput(
              ref,
              context,
              'Senha',
              senhaOperadorProvider,
              senhaVisivelOperadorProvider,
              textColor,
              labelColor,
              borderColor,
            ),
            _buildPasswordInput(
              ref,
              context,
              'Digite a senha novamente',
              repetirSenhaOperadorProvider,
              repetirSenhaVisivelOperadorProvider,
              textColor,
              labelColor,
              borderColor,
            ),

            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if ([nome, cpf, email, telefone, senha, repetirSenha,].any((field) => field.isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos')),
                    );
                    return;
                  }
                  if (senha != repetirSenha) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('As senhas não coincidem')),
                    );
                  }

                  await registerOperator(
                    context: context,
                    nome: nome,
                    cpf: cpf,
                    email: email,
                    telefone: telefone,
                    senha: senha,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: buttonTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
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
    BuildContext context,
    String label,
    StateProvider<String> provider,
    Color textColor,
    Color labelColor,
    Color borderColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        onChanged: (val) => ref.read(provider.notifier).state = val,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: labelColor),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.amber, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInput(
    WidgetRef ref,
    BuildContext context,
    String label,
    StateProvider<String> textProvider,
    StateProvider<bool> visibilidadeProvider,
    Color textColor,
    Color labelColor,
    Color borderColor,
  ) {
    final visivel = ref.watch(visibilidadeProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        obscureText: !visivel,
        onChanged: (val) => ref.read(textProvider.notifier).state = val,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: labelColor),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              visivel ? Icons.visibility : Icons.visibility_off,
              color: labelColor,
            ),
            onPressed: () {
              ref.read(visibilidadeProvider.notifier).state = !visivel;
            },
          ),
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.amber, width: 2),
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
