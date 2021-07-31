import 'package:flutter/material.dart';

class DateTimeEvent {
  String title;
  DateTime fromDate;
  DateTime toDate;
  String description;
  bool isAllDay;
  Color backgroundColor;

  DateTimeEvent({
    required this.title,
    required this.fromDate,
    required this.toDate,
    required this.description,
    this.isAllDay = false,
    this.backgroundColor = Colors.lightGreen,
  });
}
