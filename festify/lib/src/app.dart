import 'package:festify/src/features/core/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/features/auth/presentation/login_page.dart';
import '../src/features/auth/presentation/password_reset_page.dart';
import '../src/features/contract/presentation/contract_main_page.dart';
import '../src/features/contract/presentation/contract_details_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/password-reset': (context) => const PasswordResetPage(),
        '/contract-main': (context) => const ContractMainPage(),
        '/contract-details': (context) => const ContractDetailsPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ref.watch(colorProvider),
          brightness:
              ref.watch(themeSwitchProvider)
                  ? Brightness.light
                  : Brightness.dark,
        ),
      ),
    );
  }
}