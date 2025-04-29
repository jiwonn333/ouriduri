import 'package:flutter/cupertino.dart';

class AllDayToggle extends StatelessWidget {
  const AllDayToggle({super.key, required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext ctx) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text('종일', style: TextStyle(fontSize: 16)),
      CupertinoSwitch(value: value, onChanged: onChanged),
    ],
  );
}