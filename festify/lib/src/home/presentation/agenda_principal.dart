import 'package:flutter/material.dart';

import '../../features/custom_app_bar.dart';
import '../../features/custom_bottom_nav_bar.dart';
import '../../features/custom_drawer.dart';

class AgendaPrincipalPage extends StatelessWidget {
  const AgendaPrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      final textColor = isDarkMode ? Colors.white : Colors.black;
      
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const MyDrawer(),

    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Selecione uma opção',
            style: TextStyle(color: textColor, fontSize: 18),
          ),
            const SizedBox(height: 55),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOptionCard(
                  context: context,
                  icon: Icons.list,
                  label: 'Visualizar eventos',
                  onTap: () => Navigator.pushNamed(context, '/agenda-visualizacao'),
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(width: 55),
                _buildOptionCard(
                  context: context,
                  icon: Icons.block,
                  label: 'Bloquear datas',
                  onTap: () => Navigator.pushNamed(context, '/agenda-bloqueio'),
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ],
        ),
      ),

        bottomNavigationBar: CustomBottomNavBar()
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
     final cardColor = isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);
      final iconColor = isDarkMode ? Colors.white : Colors.black;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 40),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: iconColor)),
        ],
      ),
    ),
  );
}
}