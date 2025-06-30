import 'package:festify/src/features/custom_drawer.dart';
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
      endDrawer: const MyDrawer(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selecione um contrato',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  color: Color(0xFFBDBDBD),
                ),
              ),
              SizedBox(height: 40),
              ContractSearchBar(),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ContractFilter('Pendente Geração'),
                    ContractFilter('Gerado'),
                    ContractFilter('Pendente Assinatura'),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ContractCard('Gerado'),
              SizedBox(height: 12),
              ContractCard('Assinado'),
              SizedBox(height: 12),
              ContractCard('Pendente de \nAssinatura'),
              SizedBox(height: 12),
              ContractCard('Pendente de \ngeração'),
            ],
          ),
        )],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class ContractFilter extends StatelessWidget {
  final String text;

  const ContractFilter(
    String this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white,
          width: .5,
        ),
      ),
      child: Text(
        text
      ),
    );
  }
}

class ContractSearchBar extends StatelessWidget {
  const ContractSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Icon(Icons.search, color: Colors.white),
          ),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContractCard extends StatelessWidget {
  final String status;

  const ContractCard(String this.status, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/contract-details');
      },
      child: Card(
        color: Color(0xFF1E1E1E),
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CardBasicStructure(
                    titleColor: Colors.white,
                    subtitleColor: Color(0xFFD4D9E0),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status:'),
                    Text(
                      status,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
