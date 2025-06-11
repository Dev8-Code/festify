import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cadastro_pessoa_juridica_providers.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../../custom_drawer.dart';

class CadastroPessoaJuridicaPage extends ConsumerWidget {
  const CadastroPessoaJuridicaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final borderColor = isDarkMode ? Colors.white70 : Colors.black38;
    final focusColor = Colors.yellow;

    final razaoSocial = ref.watch(razaoSocialProvider);
    final cnpj = ref.watch(cnpjProvider);
    final responsavel = ref.watch(responsavelProvider);
    final email = ref.watch(emailJuridicoProvider);
    final telefone = ref.watch(telefoneJuridicoProvider);
    final isLoading = ref.watch(isLoadingCadastroJuridicoProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const MyDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'CADASTRO PESSOA JURÍDICA',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            _buildInput(context, ref, 'Razão Social', razaoSocialProvider),
            _buildInput(context, ref, 'CNPJ', cnpjProvider),
            _buildInput(context, ref, 'Responsável', responsavelProvider),
            _buildInput(context, ref, 'E-mail', emailJuridicoProvider),
            _buildInput(context, ref, 'Telefone', telefoneJuridicoProvider),

            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 500,
                height: 50,
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow,
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          foregroundColor: const Color(0xFF121E30),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () async {
                          if ([
                            razaoSocial,
                            cnpj,
                            responsavel,
                            email,
                            telefone,
                          ].any((e) => e.isEmpty)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Por favor, preencha todos os campos',
                                ),
                              ),
                            );
                            return;
                          }

                          ref
                              .read(isLoadingCadastroJuridicoProvider.notifier)
                              .state = true;
                          await Future.delayed(const Duration(seconds: 2));
                          ref
                              .read(isLoadingCadastroJuridicoProvider.notifier)
                              .state = false;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Cadastro realizado com sucesso!',
                              ),
                            ),
                          );
                        },
                        child: const Text('Cadastrar'),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildInput(
    BuildContext context,
    WidgetRef ref,
    String label,
    StateProvider<String> provider,
    
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final borderColor = isDarkMode ? Colors.white70 : Colors.black38;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        style: TextStyle(color: textColor),
        onChanged: (value) => ref.read(provider.notifier).state = value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: labelColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
          ),
        ),
      ),
    );
  }
}
