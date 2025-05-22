import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../../card_basic_structure.dart';

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
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class ContractCard extends StatelessWidget {
  const ContractCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/contract-details');
      },
      child: Card(
        color: Color(0xFF1F3A5F),
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CardBasicStructure(
                  titleColor: Colors.white,
                  subtitleColor: Color(0xFFD4D9E0),
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
      ),
    );
  }
}