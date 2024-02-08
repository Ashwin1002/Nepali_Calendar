import 'package:clean_nepali_calendar/clean_nepali_calendar.dart';
import 'package:flutter/material.dart';
// import 'package:my_calendar/utils/nepali_date_picker_utils.dart';
import 'package:my_calendar/widgets/nepali_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NepaliCalendar(
              key: UniqueKey(),
              controller: NepaliCalendarController(),
              onDaySelected: (date) {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Dialog'),
        onPressed: () async {
          // final datePicker = await showNepaliDatePicker(context);

          // // print('datePicker $datePicker');
          // final DateTimeRange? datepicker = await showDateRangePicker(
          //   context: context,
          //   firstDate: DateTime(2020),
          //   lastDate: DateTime(2025),
          // );
        },
      ),
    );
  }
}
