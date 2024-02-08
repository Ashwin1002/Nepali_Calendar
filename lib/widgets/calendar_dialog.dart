import 'package:clean_nepali_calendar/clean_nepali_calendar.dart';
import 'package:flutter/material.dart';
import 'package:my_calendar/model/nepali_date_range_picker.dart';
import 'package:my_calendar/widgets/date_cell_tile.dart';
import 'package:my_calendar/widgets/nepali_calendar.dart';

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
              NepaliCalendar(
                key: const Key('nepali_calendar_view'),
                controller: NepaliCalendarDialog._controller,
                onDaySelected: (date) {
                  if (widget.selectedDate == null) return;
                  widget.selectedDate!(date);
                  // print('start date => $_startDate && end date => $_endDate');
                },
              )
            else
              NepaliCalendar.rangePicker(
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
                    child: DateCellTile(
                      key: const Key('Dialog_Date_Cell'),
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
