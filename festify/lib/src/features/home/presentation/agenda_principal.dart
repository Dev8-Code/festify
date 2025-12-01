import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../../custom_drawer.dart';

class AgendaPrincipalPage extends StatefulWidget {
  const AgendaPrincipalPage({super.key});

  @override
  State<AgendaPrincipalPage> createState() => _AgendaPrincipalPageState();
}

class _AgendaPrincipalPageState extends State<AgendaPrincipalPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Simulação de dados do calendário
  final List<DateTime> diasEvento = [
    DateTime.now().add(const Duration(days: 1)),
    DateTime.now().add(const Duration(days: 5)),
  ];
  final List<DateTime> diasBloqueados = [
    DateTime.now().add(const Duration(days: 3)),
  ];
  final List<DateTime> diasMontagem = [
    DateTime.now().add(const Duration(days: 0)),
    DateTime.now().add(const Duration(days: 1)),
  ];
  final List<DateTime> diasDesmontagem = [
    DateTime.now().add(const Duration(days: 6)),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const MyDrawer(),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Calendário de Eventos',
              style: TextStyle(color: textColor, fontSize: 18),
            ),
            const SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day);
                },
                todayBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, isToday: true);
                },
                selectedBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, isSelected: true);
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildLegendaCalendario(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day, {bool isToday = false, bool isSelected = false}) {
    Color? bgColor;

    if (diasEvento.any((d) => isSameDay(d, day))) {
      bgColor = Colors.blue;
    } else if (diasBloqueados.any((d) => isSameDay(d, day))) {
      bgColor = Colors.red;
    } else if (diasMontagem.any((d) => isSameDay(d, day))) {
      bgColor = Colors.grey[300];
    } else if (diasDesmontagem.any((d) => isSameDay(d, day))) {
      bgColor = Colors.grey[600];
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: isToday
            ? Border.all(color: Colors.amber, width: 2)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        day.day.toString(),
        style: TextStyle(
          color: bgColor != null ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLegendaCalendario(bool isDarkMode) {
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Legenda do Calendário:',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildLegendaItem(color: Colors.blue, label: 'Dia de evento', isDarkMode: isDarkMode),
            _buildLegendaItem(color: Colors.red, label: 'Data bloqueada', isDarkMode: isDarkMode),
            _buildLegendaItem(color: Colors.grey[300]!, label: 'Montagem', isDarkMode: isDarkMode),
            _buildLegendaItem(color: Colors.grey[600]!, label: 'Desmontagem', isDarkMode: isDarkMode),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendaItem({required Color color, required String label, required bool isDarkMode}) {
    final borderColor = isDarkMode ? Colors.white70 : Colors.black45;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87)),
      ],
    );
  }
}
