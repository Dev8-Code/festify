import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/password_reset_providers.dart';
import '../notifiers/auth_notifier.dart';
import '../states/auth_state.dart';
import '../../custom_app_bar.dart';

class PasswordResetPage extends ConsumerWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final borderColor = isDarkMode ? Colors.white70 : Colors.black38;
    final focusColor = Colors.amber;

    final email = ref.watch(emailProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 220,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 125,
                      height: 125,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Redefinição de senha',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: labelColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Informe seu e-mail cadastrado e enviaremos um link para recuperação da sua senha.',
                    style: TextStyle(fontSize: 16, color: labelColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    style: TextStyle(color: textColor),
                    keyboardType: TextInputType.emailAddress,
                    onChanged:
                        (value) =>
                            ref.read(emailProvider.notifier).state = value,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
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
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:
                        isLoading
                            ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFFC107),
                              ),
                            )
                            : ElevatedButton(
                              onPressed: () async {
                                // Validação de email
                                if (email.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Por favor, informe seu e-mail',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                // Validação básica de formato de email
                                final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );
                                if (!emailRegex.hasMatch(email)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Por favor, informe um e-mail válido',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                // Inicia loading
                                ref.read(isLoadingProvider.notifier).state =
                                    true;

                                // Chama o AuthNotifier para resetar senha
                                final authNotifier = ref.read(
                                  authNotifierProvider.notifier,
                                );
                                final success = await authNotifier
                                    .resetPassword(email);

                                // Para loading
                                ref.read(isLoadingProvider.notifier).state =
                                    false;

                                if (!context.mounted) return;

                                if (success) {
                                  // Sucesso - mostra mensagem e volta para login
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Link de recuperação enviado! Verifique seu e-mail.',
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 5),
                                    ),
                                  );

                                  // Aguarda um pouco e volta para login
                                  await Future.delayed(
                                    const Duration(seconds: 2),
                                  );
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  // Erro - busca mensagem de erro do AuthNotifier
                                  final authState = ref.read(
                                    authNotifierProvider,
                                  );
                                  String errorMessage =
                                      'Erro ao enviar link de recuperação';

                                  if (authState is AuthStateError) {
                                    errorMessage = authState.message;
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 5),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD4AF37),
                                foregroundColor: const Color(0xFF121E30),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              child: const Text('ENVIAR LINK PARA REDEFINIÇÃO'),
                            ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Voltar para login',
                      style: TextStyle(color: labelColor, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
