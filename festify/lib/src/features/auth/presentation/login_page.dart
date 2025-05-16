import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/login_providers.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailProvider);
    final senha = ref.watch(senhaProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3A5F), // Azul escuro
        centerTitle: true,
        toolbarHeight: 60,
        title: Text(
          'Lamone',
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.yellow, width: 1.5),
              color: Colors.black,
            ),
            child: const Center(
              child: Text(
                'JF',
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        elevation: 0, // Tira a sombra se quiser
      ),
      backgroundColor: Color(0xFF121E30),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => ref.read(emailProvider.notifier).state = value,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              onChanged: (value) => ref.read(senhaProvider.notifier).state = value,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
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
                    child: Text('Entrar'),
                  ),
          ],
        ),
      ),
    );
  }
}
