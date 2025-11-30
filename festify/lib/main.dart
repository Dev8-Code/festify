import 'package:festify/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();

    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce, // necessário para deep links
      ),
    );

    print('Supabase inicializado com sucesso!');
  } catch (e) {
    print('Erro na inicialização: $e');
  }

  // 🔥 Listener global de eventos (inclui deep link do reset)
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final event = data.event;

    if (event == AuthChangeEvent.passwordRecovery) {
      print("🔗 Deep link recebido: password recovery");
    }
  });

  runApp(ProviderScope(child: App()));
}
