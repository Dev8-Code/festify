import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  void _goHome(BuildContext context) {
    Navigator.pushNamed(context, '/home-page');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      centerTitle: true,
      toolbarHeight: 60,
      elevation: 0,

      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: GestureDetector(
          onTap: () => _goHome(context),
          child: ClipOval(
            child: Image.asset(
              'assets/logo.png',
              width: 40,  // Ajustei para um tamanho mais visível
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),

      title: GestureDetector(
        onTap: () => _goHome(context),
        child: const Text(
          'Lamone',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ),
      ],
    );
  }
}
