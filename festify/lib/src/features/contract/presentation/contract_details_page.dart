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
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 12),
        children: [
          Column(
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
                          color: Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Status: Gerado',
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     ContractButtons(
              //       icon: Icons.note_add,
              //       text: 'Gerar \n contrato',
              //     ),
              //     ContractButtons(
              //       icon: Icons.upload_file,
              //       text: 'Upload de \n arquivos',
              //     ),
              //     ContractButtons(
              //       icon: Icons.edit_document,
              //       text: 'Assinar \n contrato',
              //     ),
              //   ],
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    ContractStepPending(),
                    ContractStepGenerated(),
                    ContractStepSignature(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              color: const Color.fromARGB(71, 255, 255, 255),
                              size: 40,
                            ),
                          ],
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Assinado',
                              style: TextStyle(
                                color: const Color.fromARGB(71, 255, 255, 255),
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 120)
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class ContractStepSignature extends StatelessWidget {
  const ContractStepSignature({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              Icons.circle_outlined,
              color: const Color.fromARGB(71, 255, 255, 255),
              size: 40,
            ),
            SizedBox(height: 4),
            Container( // linha vertical
              width: 2,
              height: 60,
              color: const Color.fromARGB(71, 255, 255, 255),
            ),
          ],
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pendente de assinatura',
              style: TextStyle(
                color: const Color.fromARGB(71, 255, 255, 255),
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 80, // altura do botão, ajuste se necessário
              width: MediaQuery.of(context).size.width * 0.6,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ContractButtons(
                      icon: Icons.upload_file,
                      text: 'Upload de arquivos',
                    ),
                    ContractButtons(
                      icon: Icons.note_alt,
                      text: 'Assinar contrato',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 120)
      ],
    );
  }
}

class ContractStepGenerated extends StatelessWidget {
  const ContractStepGenerated({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(height: 4),
            Container( // linha vertical
              width: 2,
              height: 60,
              color: Colors.white,
            ),
          ],
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Gerado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            ContractButtons(
              icon: Icons.download,
              text: 'Baixar contrato',
            ),
          ],
        ),
        SizedBox(height: 120)
      ],
    );
  }
}

class ContractStepPending extends StatelessWidget {
  const ContractStepPending({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              Icons.check_rounded,
              color: Colors.amber,
              size: 50,
            ),
            SizedBox(height: 4),
            Container(
              width: 2,
              height: 60,
              color: Colors.amber,
            ),
          ],
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pendente de geração',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            ContractButtons(
              icon: Icons.note_add,
              text: 'Gerar contrato',
            ),
          ],
        ),
        SizedBox(height: 120)
      ],
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(71, 255, 255, 255),
            ),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(71, 255, 255, 255),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
