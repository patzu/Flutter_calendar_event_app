import 'package:flutter/material.dart';

import 'date_time_event.dart';

class EventViewingPage extends StatefulWidget {
  const EventViewingPage({Key? key, required this.dateTimeEvent})
      : super(key: key);

  final DateTimeEvent dateTimeEvent;

  @override
  _EventViewingPageState createState() => _EventViewingPageState();
}

class _EventViewingPageState extends State<EventViewingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
