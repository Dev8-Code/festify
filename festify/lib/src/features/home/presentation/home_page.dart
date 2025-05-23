import 'package:flutter/material.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121E30),
      appBar: const CustomAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1F3A5F)),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Início')),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
            ),
            ListTile(leading: Icon(Icons.logout), title: Text('Sair')),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selecione uma opção',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOptionCard(
                  context: context,
                  icon: Icons.event,
                  label: 'Evento',
                  onTap: () => Navigator.pushNamed(context, '/cadastro-evento'),
                ),
                const SizedBox(width: 24),
                _buildOptionCard(
                  context: context,
                  icon: Icons.person,
                  label: 'Cliente',
                  onTap:
                      () => Navigator.pushNamed(context, '/cadastro-cliente'),
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
