import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import '../../custom_app_bar.dart';
import '../notifiers/auth_notifier.dart';
class PasswordUpdatePage extends ConsumerStatefulWidget {
  const PasswordUpdatePage({super.key});

  @override
  ConsumerState<PasswordUpdatePage> createState() => _PasswordUpdatePageState();
}

class _PasswordUpdatePageState extends ConsumerState<PasswordUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  late String _recoveryToken;

  @override
  void initState() {
    super.initState();

    final uri = Uri.base;
    final token = uri.queryParameters['code']; // Captura o token do link

    if (token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link inválido ou expirado')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      _recoveryToken = token;
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Chama o método do AuthNotifier que atualiza a senha com token
          await ref.read(authNotifierProvider.notifier)
              .resetPasswordWithToken(_newPasswordController.text, _recoveryToken);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha atualizada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final borderColor = isDarkMode ? Colors.white70 : Colors.black38;
    final focusColor = Colors.amber;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    ClipOval(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 125,
                        height: 125,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Criar Nova Senha',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Digite sua nova senha abaixo',
                      style: TextStyle(fontSize: 14, color: labelColor),
                    ),
                    const SizedBox(height: 32),
                    // Nova senha
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: !_showNewPassword,
                      style: TextStyle(color: textColor),
                      validator: ValidationBuilder(requiredMessage: 'Senha obrigatória')
                          .minLength(6)
                          .build(),
                      decoration: InputDecoration(
                        labelText: 'Nova Senha',
                        labelStyle: TextStyle(color: labelColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showNewPassword ? Icons.visibility : Icons.visibility_off,
                            color: labelColor,
                          ),
                          onPressed: () => setState(() => _showNewPassword = !_showNewPassword),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: focusColor, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Confirmar senha
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirmPassword,
                      style: TextStyle(color: textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Confirme sua senha';
                        if (value != _newPasswordController.text) return 'As senhas não correspondem';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Confirmar Nova Senha',
                        labelStyle: TextStyle(color: labelColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            color: labelColor,
                          ),
                          onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: focusColor, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFC107)))
                          : ElevatedButton(
                              onPressed: _updatePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD4AF37),
                                foregroundColor: const Color(0xFF121E30),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              child: const Text('ATUALIZAR SENHA'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
