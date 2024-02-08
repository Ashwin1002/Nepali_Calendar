import 'package:clean_nepali_calendar/clean_nepali_calendar.dart';
import 'package:flutter/material.dart';
import 'package:my_calendar/model/nepali_date_range_picker.dart';
import 'package:my_calendar/widgets/calendar_dialog.dart';

Future<NepaliDateTime?> showNepaliDatePicker(
  BuildContext context, {
  String? heading,
  void Function(NepaliDateTime)? selectedDate,
}) async {
  return await showDialog<NepaliDateTime?>(
    context: context,
    builder: (_) {
      return NepaliCalendarDialog(
        heading: heading,
        selectedDate: selectedDate,
      );
    },
  );
}

Future<NepaliDateTimeRange?> showNepaliDateRangePicker(
  BuildContext context, {
  String? heading,
  NepaliDateTime? startTime,
  NepaliDateTime? endTime,
}) async {
  return await showDialog<NepaliDateTimeRange?>(
    context: context,
    builder: (_) {
      return NepaliCalendarDialog.rangerPicker(
        heading: heading,
        startDate: startTime,
        endTime: endTime,
      );
    },
  );
}
