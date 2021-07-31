import 'package:flutter/cupertino.dart';

import 'date_time_event.dart';

class EventProvider extends ChangeNotifier {
  final List<DateTimeEvent> _events = [];

  List<DateTimeEvent> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<DateTimeEvent> get eventsOfSelectedDate => _events;


  void addEvent(DateTimeEvent event) {
    _events.add(event);
    notifyListeners();
  }
}
