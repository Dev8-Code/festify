import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../custom_drawer.dart';
import '../providers/cadastro_pessoa_fisica_providers.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import 'package:festify/src/features/auth/services/cadastracliente_service.dart';

class CadastroPessoaFisicaPage extends ConsumerWidget {
  const CadastroPessoaFisicaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final borderColor = isDarkMode ? Colors.white70 : Colors.black38;
    final focusColor = Colors.amber;

    final nome = ref.watch(nomeProvider);
    final cpf = ref.watch(cpfProvider);
    final rg = ref.watch(rgProvider);
    final email = ref.watch(emailProvider);
    final telefone = ref.watch(telefoneProvider);
    final cep = ref.watch(cepProvider);
    final numero = ref.watch(numeroProvider);
    final logradouro = ref.watch(logradouroProvider);
    final bairro = ref.watch(bairroProvider);
    final cidade = ref.watch(cidadeProvider);
    final estado = ref.watch(estadoProvider);
    final dataNascimento = ref.watch(dataNascimentoProvider);

    final isLoading = ref.watch(isLoadingCadastroProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const MyDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'CADASTRO PESSOA FÍSICA',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            _buildInput(
              context,
              ref,
              'Nome',
              nomeProvider,
              textColor,
              labelColor,
              borderColor,
              focusColor,
            ),
            _buildInput(
              context,
              ref,
              'CPF',
              cpfProvider,
              textColor,
              labelColor,
              borderColor,
              focusColor,
            ),
            _buildInput(
              context,
              ref,
              'RG',
              rgProvider,
              textColor,
              labelColor,
              borderColor,
              focusColor,
            ),
            _buildInput(
              context,
              ref,
              'E-mail',
              emailProvider,
              textColor,
              labelColor,
              borderColor,
              focusColor,
            ),
            _buildInput(
              context,
              ref,
              'Telefone',
              telefoneProvider,
              textColor,
              labelColor,
              borderColor,
              focusColor,
            ),

            _buildDateInput(
              context,
              ref,
              textColor,
              labelColor,
              borderColor,
              focusColor,
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildInput(
                    context,
                    ref,
                    'CEP',
                    cepProvider,
                    textColor,
                    labelColor,
                    borderColor,
                    focusColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInput(
                    context,
                    ref,
                    'Número',
                    numeroProvider,
                    textColor,
                    labelColor,
                    borderColor,
                    focusColor,
                  ),
                ),
              ],
            ),

            _buildInput(
              context,
              ref,
              'Logradouro',
              logradouroProvider,
              textColor,
              labelColor,
              borderColor,
              focusColor,
            ),
            _buildInput(
              context,
              ref,
              'Bairro',
              bairroProvider,
              textColor,
              labelColor,
              borderColor,
              focusColor,
            ),

            Row(
              children: [
                Expanded(
                  child: _buildInput(
                    context,
                    ref,
                    'Cidade',
                    cidadeProvider,
                    textColor,
                    labelColor,
                    borderColor,
                    focusColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInput(
                    context,
                    ref,
                    'Estado',
                    estadoProvider,
                    textColor,
                    labelColor,
                    borderColor,
                    focusColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Center(
              child: SizedBox(
                width: 500,
                height: 50,
                child:
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFFC107),
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
                            final campos = [
                              nome,
                              cpf,
                              rg,
                              email,
                              telefone,
                              cep,
                              numero,
                              logradouro,
                              bairro,
                              cidade,
                              estado,
                            ];

                            if (campos.any((e) => e.isEmpty) ||
                                dataNascimento == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Por favor, preencha todos os campos',
                                  ),
                                ),
                              );
                              return;
                            }

                            ref.read(isLoadingCadastroProvider.notifier).state =
                                true;

                            await CadastraClienteService().cadastrarFisica(
                              context: context,
                              nome: nome,
                              cpf: cpf,
                              rg: rg,
                              email: email,
                              telefone: telefone,
                              cep: cep,
                              numero: numero,
                              logradouro: logradouro,
                              bairro: bairro,
                              cidade: cidade,
                              estado: estado,
                              dataNascimento: dataNascimento,
                            );

                            ref.read(isLoadingCadastroProvider.notifier).state =
                                false;
                          },
                          child: const Text('CADASTRAR'),
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
    BuildContext context,
    WidgetRef ref,
    String label,
    StateProvider<String> provider,
    Color textColor,
    Color labelColor,
    Color borderColor,
    Color focusColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
            borderSide: BorderSide(color: focusColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDateInput(
    BuildContext context,
    WidgetRef ref,
    Color textColor,
    Color labelColor,
    Color borderColor,
    Color focusColor,
  ) {
    final dataNascimento = ref.watch(dataNascimentoProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        style: TextStyle(color: textColor),
        readOnly: true,
        controller: TextEditingController(
          text:
              dataNascimento != null
                  ? '${dataNascimento.day.toString().padLeft(2, '0')}/${dataNascimento.month.toString().padLeft(2, '0')}/${dataNascimento.year}'
                  : '',
        ),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: dataNascimento ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            ref.read(dataNascimentoProvider.notifier).state = picked;
          }
        },
        decoration: InputDecoration(
          labelText: 'Data de Nascimento',
          labelStyle: TextStyle(color: labelColor),
          suffixIcon: Icon(Icons.calendar_today, color: labelColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: focusColor, width: 2),
          ),
        ),
      ),
    );
  }
}
