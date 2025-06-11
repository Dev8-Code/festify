import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/password_reset_providers.dart';
import '../../custom_app_bar.dart';

class PasswordResetPage extends ConsumerWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Redefinição de senha',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Color(0xFFB6B9BF),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Informe um e-mail e enviaremos um link para recuperação da sua senha.',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
                fontFamily: 'Roboto',
                color: Color(0xFF7C838C),
              ),
            ),
            SizedBox(height: 28),
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
            SizedBox(height: 28),
            isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Por favor, preencha o e-mail')),
                            );
                            return;
                          }

                          ref.read(isLoadingProvider.notifier).state = true;
                          await Future.delayed(Duration(seconds: 2));
                          ref.read(isLoadingProvider.notifier).state = false;
                    
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Link enviado!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                        ),),
                        child: Text(
                          'Enviar link para redefinição',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF121E30),
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
