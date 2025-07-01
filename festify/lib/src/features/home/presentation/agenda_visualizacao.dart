// lib/src/features/home/presentation/agenda_visualizacao.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importe Flutter Riverpod
import 'package:intl/intl.dart'; // Para formatação de datas

import '../../custom_app_bar.dart';
import '../../custom_bottom_nav_bar.dart';
import '../viewmodels/event_agenda_provider.dart'; // O caminho para onde você definiu eventDetailsProvider

class AgendaVisualizacaoPage extends ConsumerWidget { // Agora é um ConsumerWidget
  final int eventId;

  const AgendaVisualizacaoPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Adicione WidgetRef ref
    // Observe o provider que busca os detalhes do evento com base no eventId
    final asyncEvent = ref.watch(eventDetailsProvider(eventId));

    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: asyncEvent.when(
        data: (event) {
          // Quando os dados são carregados com sucesso
          final formattedDate = DateFormat('dd/MM/yyyy').format(event.eventDate);
          final formattedTime = event.eventTime != null
              ? event.eventTime!.substring(0, 5)
              : 'N/A';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'EVENTO - visualização',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: const Color(0xFFFCE3D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber,
                          child: Text(
                            event.id.toString(), // ID real do evento
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        title: Text(
                          event.clientName ?? 'Nome do Cliente (N/A)',
                          style: const TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          'Tipo: ${event.eventType ?? 'N/A'}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: const Icon(Icons.more_vert, color: Colors.black),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/evento.jpg', // Se tiver imagem dinâmica, substitua
                          fit: BoxFit.cover,
                          height: 150,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.eventAddress ?? 'Endereço não disponível',
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              '$formattedDate - $formattedTime',
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Dias de Montagem: ${event.setupDays ?? 'N/A'}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Dias de Desmontagem: ${event.teardownDays ?? 'N/A'}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                              style: TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Voltar',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()), // Indicador de carregamento
        error: (err, stack) { // Tratamento de erro
          print('Erro ao carregar evento em AgendaVisualizacaoPage: $err');
          return Center(
            child: Text(
              'Erro ao carregar evento: ${err.toString()}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}