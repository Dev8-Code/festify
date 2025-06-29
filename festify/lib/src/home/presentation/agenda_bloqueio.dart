import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../features/custom_app_bar.dart';
import '../../features/custom_bottom_nav_bar.dart';
import '../../features/custom_drawer.dart';

class AgendaBloqueioDatasPage extends StatefulWidget {
  const AgendaBloqueioDatasPage({super.key});

  @override
  State<AgendaBloqueioDatasPage> createState() =>
      _AgendaBloqueioDatasPageState();
}

class _AgendaBloqueioDatasPageState extends State<AgendaBloqueioDatasPage> {
  DateTime selectedDate = DateTime.now();
  late TextEditingController _controller;
  final DateFormat formatter = DateFormat('dd/MM/yyyy', 'pt_BR');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: formatter.format(selectedDate));

    _controller.addListener(() {
      try {
        final parsedDate = formatter.parseStrict(_controller.text);
        setState(() {
          selectedDate = parsedDate;
        });
      } catch (e) {
        // Data inválida ou incompleta, não faz nada
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.white54 : Colors.black54;
    final borderColor = isDarkMode ? Colors.orange : Colors.deepOrange;
    final bgColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const MyDrawer(),
      bottomNavigationBar: const CustomBottomNavBar(),

      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Selecione a data para bloqueio:',
                style: TextStyle(color: Colors.orange, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.datetime,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'DD/MM/AAAA',
                hintStyle: TextStyle(color: hintColor),
                filled: true,
                fillColor: isDarkMode ? Colors.white12 : Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TableCalendar(
              locale: 'pt_BR',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: selectedDate,
              selectedDayPredicate: (day) => isSameDay(selectedDate, day),
              onDaySelected: (selected, focused) {
                setState(() {
                  selectedDate = selected;
                  _controller.text = formatter.format(selected);
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(color: textColor),
                weekendTextStyle: TextStyle(color: textColor.withOpacity(0.7)),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(color: textColor),
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
                rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.orange),
                weekendStyle: TextStyle(color: Colors.orangeAccent),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                // ação ao bloquear data
              },
              child: const Text(
                'Bloquear',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
