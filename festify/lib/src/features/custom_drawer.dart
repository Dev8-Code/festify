import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/app_providers.dart';
import 'package:festify/src/features/auth/notifiers/auth_notifier.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isDarkMode = !ref.watch(themeSwitchProvider);

        return Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // ... (ListTiles de Clientes, Fornecedores, Operadores) ...
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Clientes'),
                      onTap: () {
                        Navigator.pushNamed(context, '/clients-list');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.handshake),
                      title: const Text('Fornecedores'),
                      onTap: () {
                        Navigator.pushNamed(context, '/supplier-list');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_add),
                      title: const Text('Operadores'),
                      onTap: () {
                        Navigator.pushNamed(context, '/operator-list');
                      },
                    ),
                  ],
                ),
              ),

              const Divider(),

              // ListTile do Tema
              ListTile(
                leading: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                title: Text(isDarkMode ? 'Modo claro' : 'Modo escuro'),
                onTap: () {
                  ref.read(themeSwitchProvider.notifier).state =
                      !ref.read(themeSwitchProvider);
                },
              ),

              const Divider(),

              // ListTile de Sair (com Confirmação e Logout)
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Sair', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  // 1. Obtém o AuthNotifier usando o provider gerado pelo riverpod_annotation
                  final authNotifier = ref.read(authNotifierProvider.notifier);

                  // 2. Mostra diálogo de confirmação
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Confirmar saída'),
                          content: const Text('Deseja realmente sair?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Sair'),
                            ),
                          ],
                        ),
                  );

                  if (shouldLogout == true && context.mounted) {
                    // 3. Realiza logout
                    await authNotifier.logout();

                    // 4. Navega para login
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
