import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1F3A5F),
      centerTitle: true,
      toolbarHeight: 60,
      title: Text('Lamone', style: TextStyle(fontWeight: FontWeight.normal)),
      leading: Center(
        child: Image.asset(
          'logo.png',
          fit: BoxFit.contain,
          height: 90,
          width: 90,
        ),
      ),
      elevation: 0,
    );
  }
}
