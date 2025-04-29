import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateRow extends StatelessWidget {
  const DateRow({
    super.key,
    required this.label,
    required this.date,
    required this.error,
    required this.allDay,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final bool error;
  final bool allDay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext ctx) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 16)),
              Text(
                allDay
                    ? DateFormat('yyyy.MM.dd').format(date)
                    : DateFormat('yyyy.MM.dd HH:mm').format(date),
                style: TextStyle(
                  fontSize: 16,
                  color: error ? CupertinoColors.systemRed : null,
                  decoration:
                      error ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      );
}
