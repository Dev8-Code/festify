import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: BottomNavigationBar(
        backgroundColor: Color(0xFF1F3A5F),
        unselectedItemColor: Colors.white70,
        iconSize: 36,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            label: 'Cadastro',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.edit_document,
              color: Colors.white,
            ),
            label: 'Contratos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event,
              color: Colors.white,
            ),
            label: 'Agenda',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/contract-main');
              break;
            case 2:
              break;
          }
        },
      ),
    );
  }
}