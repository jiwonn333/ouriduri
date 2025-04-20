import 'package:flutter/material.dart';

class EventListButton extends StatelessWidget {
  final String event;
  final Function(String) onLongPress;

  const EventListButton(
      {super.key, required this.event, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: OutlinedButton(
        onPressed: () {},
        onLongPress: () => onLongPress(event),
        child: Text(event, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
