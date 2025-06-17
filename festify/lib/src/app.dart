import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:festify/src/features/core/providers/app_providers.dart';
import 'package:festify/src/features/auth/presentation/cadastro_pessoa_fisica_page.dart';

import '../src/features/supplier/presentation/register_supplier_page.dart';
import '../src/features/operator/presentation/register_operator_page.dart';
import '../src/features/auth/presentation/login_page.dart';
import '../src/features/auth/presentation/password_reset_page.dart';
import '../src/features/contract/presentation/contract_main_page.dart';
import '../src/features/contract/presentation/contract_details_page.dart';
import 'features/auth/presentation/cadastro_pessoa_juridica_page.dart';
import 'home/presentation/agenda_bloqueio.dart';
import 'home/presentation/agenda_principal.dart';
import 'home/presentation/agenda_visualizacao.dart';
import 'home/presentation/home_page.dart';
import 'payment/presentation/cadastro_evento_page.dart';
import 'payment/presentation/cadastro_pagamento_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      initialRoute: '/home-page',
      routes: {
        '/login': (context) => const LoginPage(),
        '/password-reset': (context) => const PasswordResetPage(),
        '/contract-main': (context) => const ContractMainPage(),
        '/contract-details': (context) => const ContractDetailsPage(),
        '/register-supplier': (context) => const RegisterSupplierPage(),
        '/register-operator': (context) => const RegisterOperatorPage(),
        '/cadastro-pessoa-fisica': (context) => const CadastroPessoaFisicaPage(),
        '/cadastro-pessoa-juridica': (context) => const CadastroPessoaJuridicaPage(),
        '/cadastro-evento': (context) => const CadastroEventoPage(),
        '/cadastro-pagamento': (context) => const CadastroPagamentoPage(),
        '/home-page': (context) => const HomePage(),
        '/agenda-principal': (context) => const AgendaPrincipalPage(),
        '/agenda-visualizacao': (context) => const AgendaVisualizacaoPage(),
        '/agenda-bloqueio': (context) => const AgendaBloqueioDatasPage(),

      },
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: CadastroEventoPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ref.watch(colorProvider),
          brightness: ref.watch(themeSwitchProvider)
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
    );
  }
}
