import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/login_providers.dart';
import '../../custom_app_bar.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailProvider);
    final senha = ref.watch(senhaProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final senhaVisivel = ref.watch(senhaVisivelProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Color(0xFF121E30),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => ref.read(emailProvider.notifier).state = value,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              onChanged: (value) => ref.read(senhaProvider.notifier).state = value,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    senhaVisivel ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    ref.read(senhaVisivelProvider.notifier).state = !senhaVisivel;
                  },
                )
              ),
              obscureText: !senhaVisivel,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/password-reset');
                  },
                  child: Text(
                    'Esqueci minha senha',
                    style: TextStyle(
                      color: Color(0xFF7C838C),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (email.isEmpty || senha.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Por favor, preencha todos os campos')),
                          );
                          return;
                        }
                        ref.read(isLoadingProvider.notifier).state = true;
                        await Future.delayed(Duration(seconds: 2));
                        ref.read(isLoadingProvider.notifier).state = false;
                  
                        // Simples validação
                        if (email == 'a@a.com' && senha == '123') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Login OK!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Login errado')),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Color(0xFFFFC107)),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 8),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Text(
                        'Enviar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}