import 'package:festify/src/features/core/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../src/features/supplier/presentation/register_supplier_page.dart';
import '../src/features/operator/presentation/register_operator_page.dart';
import '../src/features/auth/presentation/login_page.dart';
import '../src/features/auth/presentation/password_reset_page.dart';
import '../src/features/contract/presentation/contract_main_page.dart';
import '../src/features/contract/presentation/contract_details_page.dart';
import 'features/auth/presentation/cadastro_pessoa_juridica_page.dart';
import 'package:festify/src/features/auth/presentation/cadastro_pessoa_fisica_page.dart';

import 'home/presentation/home_page.dart';
import 'payment/presentation/cadastro_evento_page.dart';
import 'payment/presentation/cadastro_pagamento_page.dart';

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
        
        '/register-operator': (context) => const RegisterOperatorPage(),
        '/register-supplier': (context) => const RegisterSupplierPage(),
        
        '/cadastro-pessoa-fisica': (context) => const CadastroPessoaFisicaPage(),
        '/cadastro-pessoa-juridica': (context) => const CadastroPessoaJuridicaPage(),
        '/cadastro-evento': (context) => const CadastroEventoPage(),
        '/cadastro-pagamento': (context) => const CadastroPagamentoPage(),
        '/home-page': (context) => const HomePage(),
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
