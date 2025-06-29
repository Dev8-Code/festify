import 'package:festify/src/features/auth/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import '../providers/login_providers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final senhaVisivel = ref.watch(senhaVisivelProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Cores dinâmicas conforme tema
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.white70 : Colors.black54;
    final borderColor = isDarkMode ? Colors.white38 : Colors.black38;
    final focusedBorderColor = Colors.amber;
    final buttonBackground = Colors.yellow[700]!;
    final buttonForeground = const Color(0xFF121E30);
    final googleButtonBackground = isDarkMode ? Colors.grey[300] : Colors.white;
    final googleButtonForeground =
        isDarkMode ? Colors.black : const Color(0xFF121E30);
    final forgotPasswordColor =
        isDarkMode ? Colors.grey[400] : const Color(0xFF7C838C);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/logo.png', height: 100),
              const SizedBox(height: 24),
              Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextFormField(
                onChanged: (value) => email = value,
                validator:
                    ValidationBuilder(requiredMessage: 'Email obrigatório')
                        .required()
                        .email('Email inválido')
                        .build(),
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: hintColor),
                  labelText: 'E-mail',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: focusedBorderColor),
                  ),
                ),
              ),

              // Campo senha
              const SizedBox(height: 24),
              TextFormField(
                onChanged: (value) => senha = value,
                validator:
                    ValidationBuilder(requiredMessage: 'Senha obrigatória')
                        .minLength(6, 'Mínimo 6 caracteres')
                        .required()
                        .build(),
                obscureText: !senhaVisivel,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Senha',
                  hintStyle: TextStyle(color: hintColor),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      senhaVisivel ? Icons.visibility : Icons.visibility_off,
                      color: hintColor,
                    ),
                    onPressed: () {
                      ref.read(senhaVisivelProvider.notifier).state =
                          !senhaVisivel;
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: focusedBorderColor),
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
                    child: Text(
                      'Esqueci minha senha',
                      style: TextStyle(
                        color: forgotPasswordColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              // Botão
              // Botão Enviar
              SizedBox(
                width: 500,
                height: 50,
                child:
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.yellow,
                          ),
                        )
                        : ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            ref.read(isLoadingProvider.notifier).state = true;

                            final loginVM = ref.read(loginViewModelProvider.notifier);
                            final result = await loginVM.login(email, senha);

                            ref.read(isLoadingProvider.notifier).state = false;
                            // Check if the widget is still mounted after async operation
                            if (!context.mounted) return;

                            if (!result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Não foi possível realizar o login",
                                  ),
                                ),
                              );

                              return;
                            }

                            Navigator.pushNamed(context, '/contract-main');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonBackground,
                            foregroundColor: buttonForeground,
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
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: googleButtonForeground,
                    size: 18,
                  ),
                  label: Text(
                    'Entrar com Google',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: googleButtonForeground,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: googleButtonBackground,
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
      ),
    );
  }
}

