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
    final email = ref.watch(emailProvider);
    final isLoading = ref.watch(isLoadingProvider);

    final textColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final borderColor = isDarkMode ? Colors.white70 : Colors.black38;
    const focusColor = Colors.amber;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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

                  // ------------------------
                  // EMAIL INPUT
                  // ------------------------
                  TextField(
                    style: TextStyle(color: textColor),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) =>
                        ref.read(emailProvider.notifier).state = value,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: labelColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: focusColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ------------------------
                  // BOTÃO ENVIAR
                  // ------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFFC107),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              // -----------------------------
                              // VALIDAR EMAIL
                              // -----------------------------
                              if (email.isEmpty) {
                                _showSnack(
                                  context,
                                  'Por favor, informe seu e-mail',
                                  Colors.orange,
                                );
                                return;
                              }

                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );

                              if (!emailRegex.hasMatch(email)) {
                                _showSnack(
                                  context,
                                  'Por favor, informe um e-mail válido',
                                  Colors.orange,
                                );
                                return;
                              }

                              // Inicia loading
                              ref.read(isLoadingProvider.notifier).state = true;

                              final authNotifier =
                                  ref.read(authNotifierProvider.notifier);

                              final success =
                                  await authNotifier.resetPassword(email);

                              // Finaliza loading
                              ref.read(isLoadingProvider.notifier).state = false;

                              if (!context.mounted) return;

                              if (success) {
                                _showSnack(
                                  context,
                                  'Link de recuperação enviado! Verifique seu e-mail.',
                                  Colors.green,
                                );

                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );

                                if (context.mounted) Navigator.pop(context);
                              } else {
                                final authState =
                                    ref.read(authNotifierProvider);

                                String message =
                                    'Erro ao enviar link de recuperação';

                                if (authState is AuthStateError) {
                                  message = authState.message;
                                }

                                _showSnack(
                                  context,
                                  message,
                                  Colors.red,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              foregroundColor: const Color(0xFF121E30),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
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

                  // ------------------------
                  // VOLTAR AO LOGIN
                  // ------------------------
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

  // ---------------------------------------------
  // FUNÇÃO GLOBAL DE SNACKBAR (limpa repetição)
  // ---------------------------------------------
  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
