import 'dart:io';

import 'package:booking_app/screens/models/book_moving_cleaning_model.dart';
import 'package:booking_app/screens/user_details/user_details.dart';
import 'package:booking_app/utils/app_constants.dart';
import 'package:booking_app/widgets/my_platform_exception_alert_dialog.dart';
import 'package:booking_app/widgets/my_round_progress_button.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'date_time_event.dart';
import 'event_data_source.dart';
import 'event_editing_page.dart';
import 'event_provider.dart';
import 'tasks_widget.dart';

class CalendarScreen extends StatefulWidget {
  static String routeName = 'dateTimePicker';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    // BookMovingCleaningModel bookMovingCleaningModel =
    //     ModalRoute.of(context)!.settings.arguments as BookMovingCleaningModel;

    List<DateTimeEvent> events = Provider.of<EventProvider>(context).events;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Your Home',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: kEdgeInsetsAllPadding,
        child: Center(
          child: ListView(
            children: [
              SfCalendar(
                dataSource: EventDataSource(events),
                view: CalendarView.month,
                initialSelectedDate: DateTime.now(),
                cellBorderColor: Colors.grey,
                onLongPress: (details) {
                  final provider =
                      Provider.of<EventProvider>(context, listen: false);
                  provider.setDate(details.date!);
                },
              ),
              TasksWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventEditingPage(),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.all(16),
          height: 60,
          child: MyRoundProgressButton(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            strokeWidth: 2,
            child: Icon(
              Icons.arrow_forward,
            ),
            onPressed: (AnimationController controller) async {
              controller.forward();
              await Future.delayed(Duration(milliseconds: 500));

              // BookMovingCleaningModel? bookMovingModel =
              //     await bookMovingCleaningApiCall(bookMovingCleaningModel);

              Navigator.pushNamed(
                context,
                UserDetailsScreen.routeName,
                // arguments: bookMovingModel,
              );

              controller.reset();
            },
          ),
        ),
      ),
    );
  }

  Future<BookMovingCleaningModel?> bookMovingCleaningApiCall(
      BookMovingCleaningModel bookMovingCleaningModel) async {
    FirebaseFunctions firebaseFunctions =
        FirebaseFunctions.instanceFor(region: "europe-west1");
    String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    int port = Platform.isAndroid ? 5001 : 8080;
    firebaseFunctions.useFunctionsEmulator(host, port);
    HttpsCallable callable =
        firebaseFunctions.httpsCallable('bookMovingCleaning');
    try {
      final HttpsCallableResult result = await callable.call({
        "step": "2",
        "date": "1663321635",
        "bookingId": bookMovingCleaningModel.bookingId,
      });
      print(result.data);

      Map<String, dynamic> map = Map<String, dynamic>.from(result.data);

      return BookMovingCleaningModel.fromJson(map);
    } on FirebaseFunctionsException catch (e) {
      MyPlatformExceptionAlertDialog(
        title: 'Api call step 2 failed',
        exception: e,
      ).show(context);
      print('caught firebase functions exception');
      print(e.stackTrace);
    }
  }
}

class User {
  String? name;
  String? alias;

  User({this.name, this.alias});

  User.fromJson(Map<String, dynamic> data) {
    this.name = data['name'];
    this.alias = data['alias'];
  }
}
