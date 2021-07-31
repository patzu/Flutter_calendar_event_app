import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'date_time_event.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<DateTimeEvent> appointments) {
    this.appointments = appointments;
  }

  DateTimeEvent getEvent(int index) =>
      appointments![index] as DateTimeEvent;

  @override
  Color getColor(int index) {
    return getEvent(index).backgroundColor;
  }

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  DateTime getEndTime(int index) => getEvent(index).fromDate;

  @override
  DateTime getStartTime(int index) => getEvent(index).toDate;
}
