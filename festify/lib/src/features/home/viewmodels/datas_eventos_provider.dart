import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_agenda_model.dart';
import '../services/event_agenda_service.dart'; // Adjust import path

// Provider for the EventAgendaService
final eventAgendaServiceProvider = Provider((ref) => EventAgendaService());

// StateNotifierProvider to manage the list of all events
final datasEventosProvider = StateNotifierProvider<EventListNotifier, AsyncValue<List<Event>>>((ref) {
  return EventListNotifier(ref.watch(eventAgendaServiceProvider));
});

class EventListNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final EventAgendaService _eventAgendaService;

  EventListNotifier(this._eventAgendaService) : super(const AsyncValue.loading()) {
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final events = await _eventAgendaService.fetchAllEvents();
      state = AsyncValue.data(events);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // You might want a method to refresh the list of events
  Future<void> refreshEvents() async {
    state = const AsyncValue.loading();
    await _fetchEvents();
  }
}