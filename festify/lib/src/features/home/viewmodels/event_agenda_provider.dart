import 'package:flutter/material.dart';
import '../models/event_agenda_model.dart';
import '../services/event_agenda_service.dart';


class EventAgendaProvider with ChangeNotifier {
  Event? _event;
  bool _isLoading = false;
  String? _errorMessage;

  Event? get event => _event;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final EventAgendaService _eventService = EventAgendaService();

  Future<void> fetchEvent(int eventId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _event = await _eventService.fetchEventDetails(eventId);
    } catch (e) {
      _errorMessage = 'Falha ao carregar o evento: ${e.toString()}';
      _event = null; // Clear event on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}