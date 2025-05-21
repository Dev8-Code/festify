import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../custom_app_bar.dart';

class ContractMainPage extends ConsumerWidget {
  const ContractMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Color(0xFF121E30),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selecione um contrato',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  color: Color(0xFFBDBDBD)
                )
              ),
              SizedBox(height: 40),
              ContractCard(),
              SizedBox(height: 12),
              ContractCard(),
              SizedBox(height: 12),
              ContractCard(),
              SizedBox(height: 12),
              ContractCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
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
            // trocar de tela
          },
        ),
      ),
    );
  }
}

class ContractCard extends StatelessWidget {
  const ContractCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF1F3A5F),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFFFC107),
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Color(0xFF1F3A5F),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Título contrato',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                          color: Colors.white,
                        )
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Nome contratante',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                          color: Color(0xFFD4D9E0)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.description,
                color: Color(0xFFD4D9E0),
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}