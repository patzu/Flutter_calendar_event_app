# Flutter_calendar_event_app

Based on Youtube video at bellow link:

https://www.youtube.com/watch?v=LoDtxRkGDTw



*******************************************************************
Usage of calendar library by Syncfusion:



Add bellow dependencies:

syncfusion_flutter_core: ^19.2.49

syncfusion_flutter_calendar: ^19.2.48


```
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
