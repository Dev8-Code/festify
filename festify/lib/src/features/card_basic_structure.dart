import 'package:flutter/material.dart';

class CardBasicStructure extends StatelessWidget {
  final Color titleColor;
  final Color subtitleColor;

  const CardBasicStructure({
    super.key,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                color: titleColor,
              )
            ),
            SizedBox(height: 8),
            Text(
              'Nome contratante',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: subtitleColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}