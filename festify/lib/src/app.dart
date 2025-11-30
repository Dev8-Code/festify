import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/password_reset_page.dart';
import 'features/auth/presentation/password_update_page.dart';
import 'features/auth/widgets/auth_guard.dart';
import 'features/auth/presentation/cadastro_pessoa_fisica_page.dart';
import 'features/auth/presentation/cadastro_pessoa_juridica_page.dart';
import 'features/contract/presentation/contract_main_page.dart';
import 'features/contract/presentation/contract_details_page.dart';
import 'features/home/presentation/home_page.dart';
import 'features/home/presentation/agenda_principal.dart';
import 'features/home/presentation/agenda_bloqueio.dart';
import 'features/home/presentation/agenda_visualizacao.dart';
import 'features/payment/presentation/cadastro_evento_page.dart';
import 'features/payment/presentation/cadastro_pagamento_page.dart';
import 'features/supplier/presentation/register_supplier_page.dart';
import 'features/supplier/presentation/supplier_list_page.dart';
import 'features/operator/presentation/register_operator_page.dart';
import 'features/operator/presentation/operator_list_page.dart';
import 'features/clientes/presentation/clients_list_page.dart';
import 'features/core/providers/app_providers.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final supabase = Supabase.instance.client;

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();

    // 🔹 Tratar links de recuperação de senha no Flutter Web
    if (kIsWeb) {
      final uri = Uri.base;

      // Antes estava 'access_token', agora é 'token'
      if (uri.queryParameters['type'] == 'recovery' &&
          uri.queryParameters['token'] != null) {
        final recoveryToken = uri.queryParameters['token']!;

        // Recupera a sessão antes de redirecionar
        Supabase.instance.client.auth.recoverSession(recoveryToken).then((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState?.pushReplacementNamed(
              '/password-update',
            );
          });
        }).catchError((e) {
          debugPrint('Erro ao recuperar sessão: $e');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState?.pushReplacementNamed('/login');
          });
        });

        return; // evita o listener de auth
      }
    }

    // Listener de login normal
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.signedIn) {
        navigatorKey.currentState?.pushReplacementNamed('/home-page');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/password-reset': (_) => const PasswordResetPage(),
        '/password-update': (_) => const PasswordUpdatePage(),
        '/contract-main': (_) => AuthGuard(child: const ContractMainPage()),
        '/contract-details': (_) => AuthGuard(child: const ContractDetailsPage()),
        '/register-supplier': (_) => AuthGuard(child: const RegisterSupplierPage()),
        '/register-operator': (_) => AuthGuard(child: const RegisterOperatorPage()),
        '/cadastro-pessoa-fisica': (_) => AuthGuard(child: const CadastroPessoaFisicaPage()),
        '/cadastro-pessoa-juridica': (_) => AuthGuard(child: const CadastroPessoaJuridicaPage()),
        '/cadastro-evento': (_) => AuthGuard(child: const CadastroEventoPage()),
        '/cadastro-pagamento': (_) => AuthGuard(child: const CadastroPagamentoPage()),
        '/home-page': (_) => AuthGuard(child: const HomePage()),
        '/agenda-principal': (_) => AuthGuard(child: const AgendaPrincipalPage()),
        '/agenda-bloqueio': (_) => AuthGuard(child: const AgendaBloqueioDatasPage()),
        '/supplier-list': (_) => AuthGuard(child: const SupplierListPage()),
        '/operator-list': (_) => AuthGuard(child: const OperatorListPage()),
        '/clients-list': (_) => AuthGuard(child: const ClientListPage()),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/agenda-visualizacao') {
          final eventId = settings.arguments;
          if (eventId is int) {
            return MaterialPageRoute(
              builder: (_) => AuthGuard(child: AgendaVisualizacaoPage(eventId: eventId)),
            );
          }
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Erro de Navegação')),
              body: const Center(child: Text('Erro: ID do evento inválido.')),
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
          brightness: ref.watch(themeSwitchProvider) ? Brightness.light : Brightness.dark,
        ),
      ),
    );
  }
}
