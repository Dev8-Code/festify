import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/app_providers.dart';

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
                    ListTile(
                      leading: const Icon(Icons.handshake),
                      title: const Text('Fornecedor'),
                      onTap: () {
                        Navigator.pushNamed(context, '/supplier-list');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_add),
                      title: const Text('Operador'),
                      onTap: () {
                        Navigator.pushNamed(context, '/register-operator');
                      },
                    ),
                  ],
                ),
              ),

              const Divider(),

              ListTile(
                leading: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                title: Text(isDarkMode ? 'Modo claro' : 'Modo escuro'),
                onTap: () {
                  ref.read(themeSwitchProvider.notifier).state =
                      !ref.read(themeSwitchProvider);
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
