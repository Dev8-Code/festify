import 'package:flutter/material.dart';
import '../../custom_app_bar.dart';

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
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Início'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sair'),
            ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selecione uma opção',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
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
                  onTap: () => _showClientTypeDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121E30),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Cadastro'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Contratos'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
        ],
      ),
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
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showClientTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color.fromARGB(255, 249, 199, 38),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Selecione o tipo de cliente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                RadioListTile<String>(
                  value: 'fisica',
                  groupValue: null,
                  title: const Text('PESSOA FÍSICA'),
                  onChanged: (value) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/cadastro-cliente-fisica');
                  },
                ),
                const Divider(),
                RadioListTile<String>(
                  value: 'juridica',
                  groupValue: null,
                  title: const Text('PESSOA JURÍDICA'),
                  onChanged: (value) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/cadastro-cliente-juridica');
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Fechar',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
