import 'package:flutter/material.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';

class AgendaVisualizacaoPage extends StatelessWidget {
  const AgendaVisualizacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121E30),
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'EVENTO - visualização',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFFFCE3D9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 255, 233, 39),
                      child: Text(
                        '1',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text('Evento 1', style: TextStyle(color: Colors.black)),
                    subtitle: Text('Resumo evento 1', style: TextStyle(color: Colors.black54)),
                    trailing: Icon(Icons.more_vert, color: Colors.black),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/evento.jpg',
                      fit: BoxFit.cover,
                      height: 150,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Av. dos Alfandegários, nº 189',
                          style: TextStyle(color: Colors.black),
                        ),
                        const Text(
                          '31/03/2025 - 19h',
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 249, 224, 0),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Voltar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}