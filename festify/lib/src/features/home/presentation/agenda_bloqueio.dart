import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../../custom_drawer.dart';
import '../providers/bloqueios_manuais_provider.dart';
import '../providers/datas_eventos_provider.dart'; 
import 'agenda_visualizacao.dart';

class AgendaBloqueioDatasPage extends ConsumerStatefulWidget {
  const AgendaBloqueioDatasPage({super.key});

  @override
  ConsumerState<AgendaBloqueioDatasPage> createState() => _AgendaBloqueioDatasPageState();
}

class _AgendaBloqueioDatasPageState extends ConsumerState<AgendaBloqueioDatasPage> {
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
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final bloqueios = ref.watch(bloqueiosManuaisProvider);
    final eventsAsync = ref.watch(datasEventosProvider);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.white54 : Colors.black54;
    final borderColor = isDarkMode ? Colors.amber : Colors.deepOrange;

    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const MyDrawer(),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Selecione a data para bloqueio:',
                style: TextStyle(color: Colors.amber, fontSize: 16),
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
            eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erro ao carregar eventos: $err')),
              data: (events) {
                final eventDates = events.map((e) => e.eventDate).toList();

                return TableCalendar(
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

                    final eventOnSelectedDay = events.firstWhereOrNull(
                      (e) => isSameDay(e.eventDate, selected),
                    );

                    if (eventOnSelectedDay != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgendaVisualizacaoPage(
                            eventId: eventOnSelectedDay.id,
                          ),
                        ),
                      );
                    }
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
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
                    weekdayStyle: TextStyle(color: Colors.amber),
                    weekendStyle: TextStyle(color: Colors.amber),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final isBloqueado = bloqueios.any((d) => isSameDay(d, day));
                      final isEvento = eventDates.any((d) => isSameDay(d, day)); // Use eventDates

                      if (isBloqueado) {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      if (isEvento) {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent, 
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return null;
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: const Color(0xFF121212),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        ref.read(bloqueiosManuaisProvider.notifier).bloquear(selectedDate);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data bloqueada: ${formatter.format(selectedDate)}')),
                        );
                      },
                      child: const Text('Bloquear'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: const Color(0xFF121212),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        ref.read(bloqueiosManuaisProvider.notifier).desbloquear(selectedDate);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data desbloqueada: ${formatter.format(selectedDate)}')),
                        );
                      },
                      child: const Text('Desbloquear'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}