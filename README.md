# Flutter_calendar_event_app

Based on Youtube video at bellow link:

https://www.youtube.com/watch?v=LoDtxRkGDTw





*******************************************************************
Code snippet bellow is usage of another calendar library by Syncfusion and not related to above tutorial and files just personal note:



Add bellow dependencies:
```
syncfusion_flutter_core: ^19.2.49
syncfusion_flutter_calendar: ^19.2.48
```
## Usage
```dart
    SfCalendar(
              view: CalendarView.month,
              initialSelectedDate: DateTime.now(),
              cellBorderColor: Colors.grey,
              onTap: (details) {
                print(details.date!.microsecondsSinceEpoch);
                dateTime = details.date!;
              },
            ),
```
