import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/login_providers.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailProvider);
    final senha = ref.watch(senhaProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final senhaVisivel = ref.watch(senhaVisivelProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 24),
            const Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Campo Email
            TextField(
              decoration: InputDecoration(
                hintText: 'E-mail',
                hintStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white38),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.amber),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),

            // Campo Senha
            TextField(
              onChanged:
                  (value) => ref.read(senhaProvider.notifier).state = value,
              obscureText: !senhaVisivel,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Senha',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    senhaVisivel ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ref.read(senhaVisivelProvider.notifier).state =
                        !senhaVisivel;
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white38),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.amber),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Link esqueci senha
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/password-reset');
                  },
                  child: const Text(
                    'Esqueci minha senha',
                    style: TextStyle(color: Color(0xFF7C838C), fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Botão Enviar
            SizedBox(
              width: 500,
              height: 50,
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.yellow),
                      )
                      : ElevatedButton(
                        onPressed: () async {
                          if (email.isEmpty || senha.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Por favor, preencha todos os campos',
                                ),
                              ),
                            );
                            return;
                          }

                          ref.read(isLoadingProvider.notifier).state = true;
                          await Future.delayed(const Duration(seconds: 2));
                          ref.read(isLoadingProvider.notifier).state = false;

                          if (email == 'a@a.com' && senha == '123') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login OK!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login errado')),
                            );
                          }
                        },
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
                        child: const Text('Enviar'),
                      ),
            ),

            const SizedBox(height: 16),

            // Botão Google
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Color(0xFF121E30),
                  size: 18,
                ),
                label: const Text(
                  'Entrar com Google',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF121E30),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login com Google (não implementado)'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
