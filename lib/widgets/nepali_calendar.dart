import 'package:clean_nepali_calendar/clean_nepali_calendar.dart';
import 'package:flutter/material.dart';
import 'package:my_calendar/widgets/date_cell_tile.dart';

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

class NepaliCalendar extends StatelessWidget {
  const NepaliCalendar({
    super.key,
    required NepaliCalendarController controller,
    this.onDaySelected,
  })  : _controller = controller,
        isRangePicker = false,
        cellBuilder = null;

  const NepaliCalendar.rangePicker({
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

  return DateCellTile(
    key: const Key('Default_Cell_Decoration'),
    decoration: buildCellDecoration(),
    title: text,
    subtitle: nepaliDate.toDateTime().day.toString(),
    isDisabled: isDisabled,
    isWeekend: isWeekend,
  );
}
