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
                children: const [               
                  ListTile(
                    leading: Icon(Icons.handshake),
                    title: Text('Cadastrar Fornecedor'),
                  ),
                  ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text('Cadastrar Operador'),
                  ),
                ],
              ),
            ),

            // Área inferior: tema + logout
            Divider(),

            ListTile(
              leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: Text(isDarkMode ? 'Modo escuro' : 'Modo claro'),
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