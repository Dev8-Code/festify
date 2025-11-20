import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festify/src/features/core/providers/app_providers.dart';
import 'package:festify/src/features/auth/presentation/cadastro_pessoa_fisica_page.dart';
import 'package:festify/src/features/auth/widgets/auth_guard.dart';
import 'package:festify/src/features/auth/presentation/password_update_page.dart';
import '../src/features/supplier/presentation/register_supplier_page.dart';
import '../src/features/operator/presentation/register_operator_page.dart';
import '../src/features/auth/presentation/login_page.dart';
import '../src/features/auth/presentation/password_reset_page.dart';
import '../src/features/contract/presentation/contract_main_page.dart';
import '../src/features/contract/presentation/contract_details_page.dart';
import 'features/auth/presentation/cadastro_pessoa_juridica_page.dart';
import 'features/home/presentation/agenda_bloqueio.dart';
import 'features/home/presentation/agenda_principal.dart';
import 'features/home/presentation/agenda_visualizacao.dart';
import 'features/home/presentation/home_page.dart';
import 'payment/presentation/cadastro_evento_page.dart';
import 'payment/presentation/cadastro_pagamento_page.dart';
import '../src/features/supplier/presentation/supplier_list_page.dart';
import '../src/features/operator/presentation/operator_list_page.dart';
import '../src/features/clientes/presentation/clients_list_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/password-reset': (context) => const PasswordResetPage(),
        '/password-update': (context) => const PasswordUpdatePage(),
        '/contract-main':
            (context) => AuthGuard(child: const ContractMainPage()),
        '/contract-details':
            (context) => AuthGuard(child: const ContractDetailsPage()),
        '/register-supplier':
            (context) => AuthGuard(child: const RegisterSupplierPage()),
        '/register-operator':
            (context) => AuthGuard(child: const RegisterOperatorPage()),
        '/cadastro-pessoa-fisica':
            (context) => AuthGuard(child: const CadastroPessoaFisicaPage()),
        '/cadastro-pessoa-juridica':
            (context) => AuthGuard(child: const CadastroPessoaJuridicaPage()),
        '/cadastro-evento':
            (context) => AuthGuard(child: const CadastroEventoPage()),
        '/cadastro-pagamento':
            (context) => AuthGuard(child: const CadastroPagamentoPage()),
        '/home-page': (context) => AuthGuard(child: const HomePage()),
        '/agenda-principal':
            (context) => AuthGuard(child: const AgendaPrincipalPage()),
        '/agenda-bloqueio':
            (context) => AuthGuard(child: const AgendaBloqueioDatasPage()),
        '/supplier-list':
            (context) => AuthGuard(child: const SupplierListPage()),
        '/operator-list':
            (context) => AuthGuard(child: const OperatorListPage()),
        '/clients-list': (context) => AuthGuard(child: const ClientListPage()),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/agenda-visualizacao') {
          if (settings.arguments is int) {
            final eventId = settings.arguments as int;
            return MaterialPageRoute(
              builder:
                  (context) => AuthGuard(
                    child: AgendaVisualizacaoPage(eventId: eventId),
                  ),
            );
          }
          return MaterialPageRoute(
            builder:
                (context) => Scaffold(
                  appBar: AppBar(title: const Text('Erro de Navegação')),
                  body: const Center(
                    child: Text(
                      'Erro: ID do evento não fornecido para visualização.',
                    ),
                  ),
                ),
          );
        }
        return null;
      },
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
