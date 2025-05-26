import 'package:festify/src/features/core/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/features/supplier/presentation/register_supplier_page.dart';
import '../src/features/operator/presentation/register_operator_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      initialRoute: '/register-operator',
      routes: {
        // '/login': (context) => const LoginPage(),
        //  '/password-reset': (context) => const PasswordResetPage(),
        //  '/contract-main': (context) => const ContractMainPage(),
        //   '/contract-details': (context) => const ContractDetailsPage(),

        // Dev-Igor
        '/register-operator': (context) => const RegisterOperatorPage(),
        '/register-supplier': (context) => const RegisterSupplierPage(),
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
