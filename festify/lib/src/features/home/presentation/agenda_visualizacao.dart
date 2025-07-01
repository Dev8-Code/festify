// lib/src/features/home/presentation/agenda_visualizacao.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../../custom_drawer.dart';
import '../providers/event_agenda_provider.dart';

class AgendaVisualizacaoPage extends ConsumerWidget {
  final int eventId;

  const AgendaVisualizacaoPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEvent = ref.watch(eventDetailsProvider(eventId));

    final colorScheme = Theme.of(context).colorScheme;

    // Determine card surface color based on theme brightness
    final cardSurfaceColor = colorScheme.brightness == Brightness.dark
        ? const Color(0xFF2C2C2C) 
        : colorScheme.surfaceContainerHigh;

    final mutedTextColor = colorScheme.onSurface.withOpacity(0.7);

    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNavBar(),
      endDrawer: const MyDrawer(), 
      body: asyncEvent.when(
        data: (event) {
          final formattedDate = DateFormat('dd/MM/yyyy').format(event.eventDate);
          final formattedTime = event.eventTime != null
              ? event.eventTime!.substring(0, 5)
              : 'N/A';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'EVENTO - visualização',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6), 
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: cardSurfaceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber,
                            radius: 24,
                            child: Text(
                              event.id.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          title: Text(
                            event.clientName ?? 'Nome do Cliente (N/A)',
                            style: TextStyle(
                              color: colorScheme.onSurface, 
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'Tipo: ${event.eventType ?? 'N/A'}',
                            style: TextStyle(
                              color: mutedTextColor, 
                              fontSize: 14,
                            ),
                          ),
                          trailing: Icon(
                            Icons.more_vert,
                            color: mutedTextColor, 
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/evento.jpg', 
                            fit: BoxFit.cover,
                            height: 180,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          event.eventAddress ?? 'Endereço não disponível',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$formattedDate - $formattedTime',
                          style: TextStyle(
                            color: colorScheme.onSurface, 
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Dias de Montagem: ${event.setupDays ?? 'N/A'}',
                          style: TextStyle(
                            color: colorScheme.onSurface, // Text color on card
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dias de Desmontagem: ${event.teardownDays ?? 'N/A'}',
                          style: TextStyle(
                            color: colorScheme.onSurface, // Text color on card
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.8), // Text color with a bit less opacity
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // <<< MANTIDO Colors.amber como solicitado >>>
                              backgroundColor: Colors.amber,
                              // <<< MANTIDO Colors.black como solicitado >>>
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Voltar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          print('Erro ao carregar evento em AgendaVisualizacaoPage: $err');
          return Center(
            child: Text(
              'Erro ao carregar evento: ${err.toString()}',
              style: TextStyle(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}