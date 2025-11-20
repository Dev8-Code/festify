import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/auth_notifier.dart';
import '../states/auth_state.dart';

/// Widget que protege rotas verificando autenticação
/// Redireciona para login se o usuário não estiver autenticado
class AuthGuard extends ConsumerWidget {
  final Widget child;
  final String loginRoute;

  const AuthGuard({super.key, required this.child, this.loginRoute = '/login'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    // Usando pattern matching direto da classe
    if (authState is AuthStateInitial || authState is AuthStateLoading) {
      return const _LoadingScreen();
    }

    if (authState is AuthStateAuthenticated) {
      return child;
    }

    if (authState is AuthStateUnauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(loginRoute);
        }
      });
      return const _LoadingScreen();
    }

    if (authState is AuthStateError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(loginRoute);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro de autenticação: ${authState.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      return const _LoadingScreen();
    }

    // Fallback
    return const _LoadingScreen();
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
