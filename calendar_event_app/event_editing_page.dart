import 'package:booking_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'date_time_event.dart';
import 'event_provider.dart';

class EventEditingPage extends StatefulWidget {
  const EventEditingPage({Key? key, this.dateTimeEvent}) : super(key: key);

  final DateTimeEvent? dateTimeEvent;

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;

  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.dateTimeEvent == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingAction(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              SizedBox(height: 16),
              buildDateTimePicker(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEditingAction() {
    return [
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: saveForm,
        icon: Icon(Icons.check),
        label: Text('Save'),
      ),
    ];
  }

  Widget buildTitle() {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      controller: titleController,
      autofocus: true,
      validator: (value) => value!.isEmpty ? 'Title cannot be empty!' : null,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add title',
      ),
      onFieldSubmitted: (_) => saveForm(),
    );
  }

  Widget buildDateTimePicker() {
    return Column(
      children: [
        buildFrom(),
        SizedBox(
          height: 12,
        ),
        buildTo(),
      ],
    );
  }

  Widget buildFrom() {
    return buildHeader(
      header: 'From',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropDownField(
              text: Utils.toDate(fromDate),
              onClick: () => pickFromDateTime(pickDate: true),
            ),
          ),
          Expanded(
            child: buildDropDownField(
              text: Utils.toTime(fromDate),
              onClick: () => pickFromDateTime(pickDate: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTo() {
    return buildHeader(
      header: 'To',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropDownField(
              text: Utils.toDate(toDate),
              onClick: () {
                pickToDateTime(pickDate: true);
              },
            ),
          ),
          Expanded(
            child: buildDropDownField(
              text: Utils.toTime(toDate),
              onClick: () {
                pickToDateTime(pickDate: false);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropDownField(
      {required String text, required Function() onClick}) {
    return ListTile(
      onTap: onClick,
      title: Text(text),
      trailing: Icon(Icons.arrow_drop_down),
    );
  }

  Widget buildHeader({required String header, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        child,
      ],
    );
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if (date == null) return null;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );

    if (date == null) return null;

    if (date.isBefore(fromDate)) {}

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() {
      toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      if (date == null) return null;

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);

      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Future? saveForm() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      var event = DateTimeEvent(
        title: titleController.text,
        fromDate: fromDate,
        toDate: toDate,
        description: 'Description',
        isAllDay: false,
      );

      final provider = Provider.of<EventProvider>(
        context,
        listen: false,
      );
      provider.addEvent(event);
      Navigator.of(context).pop();
    }
  }
}
