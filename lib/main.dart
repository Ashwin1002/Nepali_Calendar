import 'package:clean_nepali_calendar/clean_nepali_calendar.dart';
import 'package:flutter/material.dart';
import 'package:my_calendar/nepali_date_range_picker.dart';

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
            _NepaliCalendar(
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
          final datePicker = await showDialog(
            context: context,
            builder: (context) {
              return const NepaliCalendarDialog();
            },
          );

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

typedef NepaliDatePickerFunc = void Function(NepaliDateTime date);

class NepaliCalendarDialog extends StatefulWidget {
  const NepaliCalendarDialog({
    super.key,
    this.heading,
    this.selectedDate,
  })  : startDate = null,
        endTime = null,
        isRangerPicker = false;

  const NepaliCalendarDialog.rangerPicker({
    super.key,
    this.startDate,
    this.endTime,
    this.heading,
  })  : isRangerPicker = true,
        selectedDate = null;

  static final _controller = NepaliCalendarController();

  final NepaliDateTime? startDate;
  final NepaliDateTime? endTime;
  final String? heading;
  final bool isRangerPicker;
  final NepaliDatePickerFunc? selectedDate;

  @override
  State<NepaliCalendarDialog> createState() => _NepaliCalendarDialogState();
}

class _NepaliCalendarDialogState extends State<NepaliCalendarDialog> {
  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endTime;
  }

  NepaliDateTime? _startDate;
  NepaliDateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 20.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                widget.heading ?? 'Select Date',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 10.0),
            if (!widget.isRangerPicker)
              _NepaliCalendar(
                key: const Key('nepali_calendar_view'),
                controller: NepaliCalendarDialog._controller,
                onDaySelected: (date) {
                  if (widget.selectedDate == null) return;
                  widget.selectedDate!(date);
                  // print('start date => $_startDate && end date => $_endDate');
                },
              )
            else
              _NepaliCalendar.rangePicker(
                key: const Key('nepali_calendar_view'),
                controller: NepaliCalendarDialog._controller,
                onDaySelected: (date) {
                  if (_startDate == null) {
                    setState(() {
                      _startDate = date;
                    });
                  } else if (_startDate != null && _startDate == date) {
                    setState(() {
                      _startDate = date;
                      _endDate = null;
                    });
                  } else if (_startDate != null && date.isBefore(_startDate!)) {
                    setState(() {
                      _startDate = date;
                    });
                  } else if (_startDate != null) {
                    setState(() {
                      _endDate = date;
                    });
                  } else if (_startDate != null && _endDate != null) {
                    setState(() {
                      _startDate = date;
                      _endDate = null;
                    });
                  } else if (_startDate != null &&
                      _endDate != null &&
                      _endDate!.isBefore(_startDate!)) {
                    setState(() {
                      _startDate = date;
                      _endDate = null;
                    });
                  } else if (_startDate == _endDate) {
                    setState(() {
                      _startDate = date;
                      _endDate = null;
                    });
                  }

                  // print('start date => $_startDate && end date => $_endDate');
                },
                cellBuilder:
                    (_, __, isDisabled, nepaliDate, label, text, ___, ____) {
                  String start = _startDate != null
                      ? _startDate.toString().substring(0, 10)
                      : '';
                  String end = _endDate != null
                      ? _endDate.toString().substring(0, 10)
                      : '';
                  String currDate = nepaliDate.toString().substring(0, 10);

                  bool isStart = start == currDate;
                  bool isEnd = end == currDate;

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: isStart || isEnd ? Colors.deepPurple : null,
                      shape: isStart || isEnd
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                    ),
                    child: _DateCellTile(
                      decoration: isDisabled
                          ? const BoxDecoration()
                          : BoxDecoration(
                              color: _startDate != null &&
                                          _startDate!.isBefore(nepaliDate) &&
                                          _endDate != null &&
                                          _endDate!.isAfter(nepaliDate) ||
                                      isStart ||
                                      isEnd
                                  ? Colors.deepPurple.withOpacity(.2)
                                  : null,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(
                                  isStart || _endDate == null ? 30.0 : 0,
                                ),
                                right: Radius.circular(
                                  isEnd || _endDate == null ? 30.0 : 0.0,
                                ),
                              ),
                            ),
                      title: text,
                      subtitle: nepaliDate.toDateTime().day.toString(),
                      isDisabled: isDisabled,
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      textColor: isStart || isEnd ? Colors.white : null,
                    ),
                  );
                },
              ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (widget.isRangerPicker) {
                      if (_startDate == null && _endDate == null) {
                        Navigator.pop(context);
                        return;
                      }
                      Navigator.of(context).pop<NepaliDateTimeRange>(
                        NepaliDateTimeRange(
                          start: _startDate!,
                          end: _endDate!,
                        ),
                      );
                      return;
                    }
                    Navigator.of(context)
                        .pop(NepaliCalendarDialog._controller.selectedDay);
                    // print(
                    //     'selected day => ${NepaliCalendarDialog._controller.selectedDay}');
                  },
                  child: const Text('Confirm'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

typedef CellBuilder = Widget Function(
  bool isToday,
  bool isSelected,
  bool isDisabled,
  NepaliDateTime nepaliDate,
  String label,
  String text,
  CalendarStyle style,
  bool isWeekEnd,
);

class _NepaliCalendar extends StatelessWidget {
  const _NepaliCalendar({
    super.key,
    required NepaliCalendarController controller,
    this.onDaySelected,
  })  : _controller = controller,
        isRangePicker = false,
        cellBuilder = null;

  const _NepaliCalendar.rangePicker({
    super.key,
    required NepaliCalendarController controller,
    this.onDaySelected,
    this.cellBuilder,
  })  : _controller = controller,
        isRangePicker = true;

  final NepaliCalendarController _controller;
  final void Function(NepaliDateTime date)? onDaySelected;
  final bool isRangePicker;
  final CellBuilder? cellBuilder;

  @override
  Widget build(BuildContext context) {
    return CleanNepaliCalendar(
      controller: _controller,
      calendarStyle: const CalendarStyle(
        dayStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        todayStyle: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
        highlightSelected: true,
        renderDaysOfWeek: true,
        highlightToday: true,
      ),
      headerDayBuilder: (String weekDay, int index) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              weekDay,
              style: TextStyle(
                color: index == 6 ? Colors.red : null,
              ),
            ),
          ),
        );
      },
      headerDayType: HeaderDayType.initial,
      initialDate: NepaliDateTime.now().toLocal(),
      language: Language.nepali,
      enableVibration: false,
      dateCellBuilder: cellBuilder ?? widgetCellBuilder,
      onDaySelected: onDaySelected,
      // selectableDayPredicate: ,
    );
  }
}

Widget widgetCellBuilder(
  bool isToday,
  bool isSelected,
  bool isDisabled,
  NepaliDateTime nepaliDate,
  String label,
  String text,
  CalendarStyle calendarStyle,
  bool isWeekend, {
  bool isRangerPicker = false,
  NepaliDateTime? startDateRange,
  NepaliDateTime? endDateRange,
}) {
  Decoration buildCellDecoration() {
    if (isDisabled) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      );
    }
    if (isSelected && isToday) {
      return BoxDecoration(
        // borderRadius: BorderRadius.circular(8),
        color: Colors.blue.shade700.withOpacity(0.75),
        border: Border.all(color: calendarStyle.selectedColor, width: 2.0),
        shape: BoxShape.circle,
      );
    }
    if (isSelected) {
      return BoxDecoration(
        // borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: calendarStyle.selectedColor,
          width: 1.5,
        ),
        shape: BoxShape.circle,
      );
    } else if (isToday && calendarStyle.highlightToday) {
      return BoxDecoration(
        // borderRadius: BorderRadius.circular(8),
        color: Colors.blue.shade700.withOpacity(0.75),
        shape: BoxShape.circle,
      );
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.transparent),
      );
    }
  }

  return _DateCellTile(
    key: const Key('Default_Cell_Decoration'),
    decoration: buildCellDecoration(),
    title: text,
    subtitle: nepaliDate.toDateTime().day.toString(),
    isDisabled: isDisabled,
    isWeekend: isWeekend,
  );
}

class _DateCellTile extends StatelessWidget {
  const _DateCellTile({
    super.key,
    required this.decoration,
    required this.title,
    required this.subtitle,
    this.isWeekend = false,
    this.isDisabled = false,
    this.margin,
    this.textColor,
  });
  final String title;
  final String subtitle;
  final Decoration decoration;
  final bool isWeekend;
  final bool isDisabled;
  final EdgeInsetsGeometry? margin;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: margin ?? const EdgeInsets.all(.5),
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      duration: const Duration(milliseconds: 2000),
      decoration: decoration,
      curve: Curves.easeIn,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                color: isWeekend
                    ? Colors.red
                    : isDisabled
                        ? Colors.grey.shade500
                        : textColor,
              ),
            ),
            // to show events
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 4.0),
                  //   child: CircleAvatar(
                  //     radius: 2.3,
                  //     backgroundColor:
                  //         nepaliDate.weekday == 7 ? Colors.red : Colors.yellow,
                  //   ),
                  // ),
                  const Spacer(),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: isWeekend
                          ? Colors.red
                          : isDisabled
                              ? Colors.grey.shade500
                              : textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
