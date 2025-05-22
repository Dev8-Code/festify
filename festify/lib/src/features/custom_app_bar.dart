import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1F3A5F),
      centerTitle: true,
      toolbarHeight: 60,
      elevation: 0,

      // Ícone do menu sanduíche
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),

      // Título com o nome e a logo
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'logo.png',
            fit: BoxFit.contain,
            height: 40,
          ),
          const SizedBox(width: 8),
          const Text(
            'Lamone',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
