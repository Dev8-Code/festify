import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/auth_notifier.dart';

/// Widget que protege rotas verificando autenticação
/// Redireciona para login se o usuário não estiver autenticado
class AuthGuard extends ConsumerWidget {
  final Widget child;
  final String loginRoute;

  const AuthGuard({super.key, required this.child, this.loginRoute = '/login'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      /// Estado inicial - mostra loading
      initial: () => const _LoadingScreen(),

      /// Estado de carregamento - mostra loading
      loading: () => const _LoadingScreen(),

      /// Usuário autenticado - exibe o widget protegido
      authenticated: (usuario) {
        // Também podemos passar o usuário para o widget se necessário
        return child;
      },

      /// Usuário não autenticado - redireciona para login
      unauthenticated: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed(loginRoute);
          }
        });
        return const _LoadingScreen();
      },

      /// Erro na autenticação - redireciona para login
      error: (message) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed(loginRoute);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro de autenticação: $message'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
        return const _LoadingScreen();
      },
    );
  }
}

/// Tela de carregamento exibida enquanto verifica autenticação
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Carregando...', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
