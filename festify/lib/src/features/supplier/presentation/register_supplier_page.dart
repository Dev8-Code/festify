import 'package:festify/src/features/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festify/src/features/custom_app_bar.dart';
import 'package:festify/src/features/custom_bottom_nav_bar.dart';
import 'package:festify/src/features/supplier/providers/register_supplier_providers.dart';

class RegisterSupplierPage extends ConsumerWidget {
  const RegisterSupplierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nome = ref.watch(nomeFornecedorProvider);
    final cnpj = ref.watch(cnpjFornecedorProvider);
    final razao = ref.watch(razaoSocialFornecedorProvider);
    final email = ref.watch(emailFornecedorProvider);
    final telefone = ref.watch(telefoneFornecedorProvider);

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
                'CADASTRO FORNECEDOR',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: 'Nome empresa',
              value: nome,
              onChanged:
                  (val) =>
                      ref.read(nomeFornecedorProvider.notifier).state = val,
            ),
            _buildInputField(
              label: 'CNPJ',
              value: cnpj,
              onChanged:
                  (val) =>
                      ref.read(cnpjFornecedorProvider.notifier).state = val,
            ),
            _buildInputField(
              label: 'Razão social',
              value: razao,
              onChanged:
                  (val) =>
                      ref.read(razaoSocialFornecedorProvider.notifier).state =
                          val,
            ),
            _buildInputField(
              label: 'E-mail',
              value: email,
              onChanged:
                  (val) =>
                      ref.read(emailFornecedorProvider.notifier).state = val,
            ),
            _buildInputField(
              label: 'Telefone',
              value: telefone,
              onChanged:
                  (val) =>
                      ref.read(telefoneFornecedorProvider.notifier).state = val,
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if ([
                    nome,
                    cnpj,
                    razao,
                    email,
                    telefone,
                  ].any((field) => field.isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos')),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fornecedor cadastrado com sucesso!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: const Color(0xFF121E30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildInputField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return TextField(
            onChanged: onChanged,
            style: TextStyle(color: theme.colorScheme.onBackground),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(
                color: theme.colorScheme.onBackground.withOpacity(0.6),
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.onBackground.withOpacity(0.4),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.amber, width: 2),
              ),
            ),
          );
        },
      ),
    );
  }
}
