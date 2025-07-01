import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../../custom_drawer.dart';
import '../providers/bloqueios_manuais_provider.dart';
import '../providers/datas_eventos_provider.dart';
import '../models/event_agenda_model.dart';
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
      } catch (_) {
        // Ignora erros de parsing durante a digitação
      }
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

  Set<DateTime> _getSetupTeardownDates(List<Event> events) {
    final Set<DateTime> setupTeardownDates = {};
    for (var event in events) {
      // Dias de Montagem
      if (event.setupDays != null && event.setupDays! > 0) {
        for (int i = 1; i <= event.setupDays!; i++) {
          final setupDate = event.eventDate.subtract(Duration(days: i));
          setupTeardownDates.add(DateTime(setupDate.year, setupDate.month, setupDate.day));
        }
      }
      // Dias de Desmontagem
      if (event.teardownDays != null && event.teardownDays! > 0) {
        for (int i = 1; i <= event.teardownDays!; i++) {
          final teardownDate = event.eventDate.add(Duration(days: i));
          setupTeardownDates.add(DateTime(teardownDate.year, teardownDate.month, teardownDate.day));
        }
      }
    }
    return setupTeardownDates;
  }

  @override
  Widget build(BuildContext context) {
    final bloqueios = ref.watch(bloqueiosManuaisProvider);
    final asyncEvents = ref.watch(datasEventosProvider);
    final colorScheme = Theme.of(context).colorScheme;

    Set<DateTime> eventDates = {};
    Set<DateTime> setupTeardownDates = {};
    List<Event> allEvents = []; // Para ter acesso à lista completa de eventos

    asyncEvents.whenOrNull(
      data: (events) {
        allEvents = events; // Armazena todos os eventos
        eventDates = events.map((e) => DateTime(e.eventDate.year, e.eventDate.month, e.eventDate.day)).toSet();
        setupTeardownDates = _getSetupTeardownDates(events);
      },
    );

    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNavBar(),
      endDrawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Data Selecionada',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                    _controller.text = formatter.format(selectedDate);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            asyncEvents.when(
              data: (events) {
                return TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: selectedDate,
                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  // >>> MODIFICAÇÃO PRINCIPAL AQUI: Lógica de navegação <<<
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectedDate = selectedDay;
                      _controller.text = formatter.format(selectedDate);
                    });

                    // Verifica se o dia selecionado é uma data de evento
                    final eventForSelectedDay = allEvents.firstWhereOrNull(
                      (event) => isSameDay(event.eventDate, selectedDay),
                    );

                    if (eventForSelectedDay != null) {
                      // Se encontrou um evento, navega para a página de visualização
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgendaVisualizacaoPage(eventId: eventForSelectedDay.id),
                        ),
                      );
                    }
                  },
                  // <<< FIM DA MODIFICAÇÃO PRINCIPAL >>>
                  calendarFormat: CalendarFormat.month,
                  locale: 'pt_BR',
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(color: Colors.amber, fontSize: 18.0),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.amber),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.amber),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: const TextStyle(color: Colors.amber),
                    weekendStyle: const TextStyle(color: Colors.yellow),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: colorScheme.onSurface),
                    weekendTextStyle: TextStyle(color: colorScheme.error),
                    outsideTextStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                    todayDecoration: BoxDecoration(
                      color: Colors.amberAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, date, _) {
                      final day = DateTime(date.year, date.month, date.day);
                      Color? backgroundColor;
                      Color textColor = colorScheme.onSurface;

                      if (bloqueios.any((b) => isSameDay(b, day))) {
                        backgroundColor = Colors.red.withOpacity(0.5);
                        textColor = Colors.white;
                      } else if (eventDates.any((e) => isSameDay(e, day))) {
                        backgroundColor = Colors.blue.withOpacity(0.5);
                        textColor = Colors.white;
                      } else if (setupTeardownDates.any((st) => isSameDay(st, day))) {
                        backgroundColor = Colors.grey[400]?.withOpacity(0.5);
                        textColor = colorScheme.onSurface;
                      }

                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(color: textColor),
                        ),
                      );
                    },
                    todayBuilder: (context, date, _) {
                      final day = DateTime(date.year, date.month, date.day);
                      Color? backgroundColor;
                      Color textColor = colorScheme.onSurface;

                      if (bloqueios.any((b) => isSameDay(b, day))) {
                        backgroundColor = Colors.red.withOpacity(0.5);
                        textColor = Colors.white;
                      } else if (eventDates.any((e) => isSameDay(e, day))) {
                        backgroundColor = Colors.blue.withOpacity(0.5);
                        textColor = Colors.white;
                      } else if (setupTeardownDates.any((st) => isSameDay(st, day))) {
                        backgroundColor = Colors.grey[400]?.withOpacity(0.5);
                        textColor = colorScheme.onSurface;
                      } else {
                        backgroundColor = colorScheme.primary.withOpacity(0.2);
                        textColor = colorScheme.onSurface;
                      }

                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amber, width: 2.5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(color: textColor),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) {
                print('Erro ao carregar eventos no calendário: $err');
                return Center(child: Text('Erro ao carregar eventos: $err'));
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
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
                          SnackBar(content: Text('Data bloqueada: ${formatter.format(selectedDate)}')
                          ),
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
                        backgroundColor: const Color.fromARGB(255, 128, 105, 32),
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
                        ref.read(bloqueiosManuaisProvider.notifier).desbloquear(selectedDate, context: context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data desbloqueada: ${formatter.format(selectedDate)}')
                          ),
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