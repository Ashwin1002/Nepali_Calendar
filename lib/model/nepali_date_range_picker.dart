import 'package:clean_nepali_calendar/clean_nepali_calendar.dart';
import 'package:flutter/material.dart';

@immutable
class NepaliDateTimeRange {
  /// Creates a NepaliDate range for the given start and end [NepaliDateTime].
  NepaliDateTimeRange({
    required this.start,
    required this.end,
  }) : assert(!start.isAfter(end));

  /// The start of the range of NepaliDates.
  final NepaliDateTime start;

  /// The end of the range of NepaliDates.
  final NepaliDateTime end;

  /// Returns a [Duration] of the time between [start] and [end].
  ///
  /// See [NepaliDateTime.difference] for more details.
  Duration get duration => end.difference(start);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is NepaliDateTimeRange &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start - $end';
}
