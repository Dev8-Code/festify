import 'package:festify/src/features/auth/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import '../providers/login_providers.dart';
import '../../custom_app_bar.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String senha = "";

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginViewModelProvider);
    final senhaVisivel = ref.watch(senhaVisivelProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Color(0xFF121E30),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
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
              TextFormField(
                onChanged: (value) => email = value,
                validator:
                    ValidationBuilder()
                        .email('Email inválido')
                        .required('Email obrigatório')
                        .build(),
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                onChanged: (value) => senha = value,
                validator:
                    ValidationBuilder()
                        .minLength(6, 'Mínimo 6 caracteres')
                        .required('Senha obrigatória')
                        .build(),
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
                      ref.read(senhaVisivelProvider.notifier).state =
                          !senhaVisivel;
                    },
                  ),
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
                      style: TextStyle(color: Color(0xFF7C838C), fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              switch (viewModel) {
                AsyncLoading() => const CircularProgressIndicator(),
                _ => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      final loginVM = ref.read(loginViewModelProvider.notifier);
                      final result = await loginVM.login(email, senha);

                      // Check if the widget is still mounted after async operation
                      if (!context.mounted) return;

                      if (!result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Não foi possível realizar o login")),
                        );
                        return;
                      }

                      Navigator.pushNamed(context, '/contract-main');
                  },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Color(0xFFFFC107),
                      ),
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
              },
            ],
          ),
        ),
      ),
    );
  }
}
