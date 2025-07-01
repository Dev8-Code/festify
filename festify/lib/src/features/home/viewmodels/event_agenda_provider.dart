// lib/src/features/home/providers/event_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_agenda_model.dart'; // Seu modelo de Evento
import '../services/event_agenda_service.dart'; // Seu serviço de eventos

// Define o estado que o StateNotifier vai gerenciar
class EventState {
  final Event? event;
  final bool isLoading;
  final String? errorMessage;

  EventState({
    this.event,
    this.isLoading = false,
    this.errorMessage,
  });

  EventState copyWith({
    Event? event,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventState(
      event: event ?? this.event,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// O StateNotifier que irá gerenciar o estado do evento
class EventNotifier extends StateNotifier<EventState> {
  final EventAgendaService _eventService;

  EventNotifier(this._eventService) : super(EventState()); // Estado inicial

  Future<void> fetchEvent(int eventId) async {
    state = state.copyWith(isLoading: true, errorMessage: null); // Atualiza o estado para carregando

    try {
      final fetchedEvent = await _eventService.fetchEventDetails(eventId);
      state = state.copyWith(event: fetchedEvent, isLoading: false); // Sucesso
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Falha ao carregar o evento: ${e.toString()}',
        isLoading: false,
        event: null, // Limpa o evento em caso de erro
      );
      print('Erro no EventNotifier.fetchEvent: ${state.errorMessage}');
    }
  }

  void clearEvent() {
    state = EventState(); // Reseta o estado para o padrão
  }
}

// O provider global para o EventNotifier
// Note: Este é um StateNotifierProvider normal, não um .family
final eventNotifierProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  // Você pode passar dependências para o seu Notifier aqui
  return EventNotifier(EventAgendaService());
});

// Um FutureProvider.family para buscar um único evento, mais direto para este caso
// Isso substitui a necessidade do EventNotifier.fetchEvent explícito
final eventDetailsProvider = FutureProvider.family<Event, int>((ref, eventId) async {
  return await EventAgendaService().fetchEventDetails(eventId);
});