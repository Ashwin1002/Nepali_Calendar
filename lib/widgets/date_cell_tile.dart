import 'package:flutter/material.dart';

class DateCellTile extends StatelessWidget {
  const DateCellTile({
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
