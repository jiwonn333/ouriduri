import 'package:flutter/cupertino.dart';

import 'event_list_button.dart';

class EventList extends StatelessWidget {
  final List<String> events;
  final Function(String) onLongPress;

  const EventList({super.key, required this.events, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return SizedBox();
    return events.length > 3
        ? Container(
            height: 300,
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return EventListButton(
                    event: events[index], onLongPress: onLongPress);
              },
            ),
          )
        : Column(
            children: events
                .map((e) => EventListButton(event: e, onLongPress: onLongPress))
                .toList(),
          );
  }
}
