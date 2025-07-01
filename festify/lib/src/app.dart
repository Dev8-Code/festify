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

import 'features/home/presentation/agenda_bloqueio.dart';
import 'features/home/presentation/agenda_principal.dart';
import 'features/home/presentation/agenda_visualizacao.dart'; // Página que precisa do ID
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
      // Mantém suas rotas existentes aqui.
      // Apenas '/agenda-visualizacao' foi removida para ser tratada por onGenerateRoute.
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
        // A rota '/agenda-visualizacao' NÃO está mais aqui.
        '/agenda-bloqueio': (context) => const AgendaBloqueioDatasPage(),
        '/supplier-list': (context) => const SupplierListPage(),
        '/operator-list': (context) => const OperatorListPage(),
        '/clients-list': (context) => const ClientListPage(),
      },
      // Adiciona onGenerateRoute para lidar com rotas que precisam de argumentos dinâmicos.
      onGenerateRoute: (settings) {
        // Trata especificamente a rota '/agenda-visualizacao'.
        if (settings.name == '/agenda-visualizacao') {
          // Verifica se um 'eventId' foi passado como argumento.
          if (settings.arguments is int) {
            final eventId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => AgendaVisualizacaoPage(eventId: eventId),
            );
          }
          // Caso o 'eventId' não seja fornecido ou seja do tipo errado, exibe uma página de erro.
          return MaterialPageRoute(
            builder: (context) => Scaffold( // 'const' removido aqui
              appBar: AppBar(title: const Text('Erro de Navegação')), // 'const' removido aqui no AppBar
              body: const Center(
                child: Text('Erro: ID do evento não fornecido para visualização.'),
              ),
            ),
          );
        }
        // Retorna null para que as outras rotas (definidas no mapa 'routes')
        // sejam tratadas normalmente pelo MaterialApp.
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