import 'package:festify/src/features/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../../card_basic_structure.dart';

class ContractDetailsPage extends ConsumerWidget {
  const ContractDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const MyDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              color: Color(0xFFF0DBD1),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CardBasicStructure(
                      titleColor: Colors.black,
                      subtitleColor: Colors.black,
                    ),
                    SizedBox(height: 36),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1F3A5F),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Status: pendente de geração, clique em "gerar contrato"',
                          style: TextStyle(
                            color: Color(0xFFD4D9E0),
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContractButtons(
                  icon: Icons.note_add,
                  text: 'Gerar \n contrato',
                ),
                ContractButtons(
                  icon: Icons.upload_file,
                  text: 'Upload de \n arquivos',
                ),
                ContractButtons(
                  icon: Icons.edit_document,
                  text: 'Assinar \n contrato',
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class ContractButtons extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContractButtons({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          iconSize: 35,
          elevation: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
